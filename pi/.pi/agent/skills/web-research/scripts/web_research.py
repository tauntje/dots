#!/usr/bin/env python3
"""Small, dependency-free web search and page-text helper for the web-research skill."""

from __future__ import annotations

import argparse
import html
from html.parser import HTMLParser
import ipaddress
import re
import socket
import ssl
import sys
from urllib.error import HTTPError, URLError
from urllib.parse import parse_qs, urlencode, urljoin, urlparse
from urllib.request import HTTPRedirectHandler, HTTPSHandler, ProxyHandler, Request, build_opener

try:
    import certifi

    TLS_CONTEXT = ssl.create_default_context(cafile=certifi.where())
except (ImportError, OSError, ssl.SSLError):
    TLS_CONTEXT = ssl.create_default_context()

USER_AGENT = "Mozilla/5.0"
TIMEOUT_SECONDS = 20
MAX_RESPONSE_BYTES = 2_000_000


def validate_public_url(url: str) -> None:
    """Reject non-web schemes, credential-bearing URLs, and non-public destinations."""
    try:
        parsed = urlparse(url)
        port = parsed.port
    except ValueError as exc:
        raise URLError(f"Invalid URL: {exc}") from exc
    if parsed.scheme not in {"http", "https"} or not parsed.hostname:
        raise URLError("Only absolute HTTP(S) URLs are supported.")
    if parsed.username is not None or parsed.password is not None:
        raise URLError("URLs containing credentials are not allowed.")
    expected_port = 443 if parsed.scheme == "https" else 80
    if port not in {None, expected_port}:
        raise URLError("Only standard HTTP(S) ports are allowed.")

    host = parsed.hostname.rstrip(".")
    try:
        addresses = {ipaddress.ip_address(host)}
    except ValueError:
        try:
            addresses = {
                ipaddress.ip_address(info[4][0].split("%", 1)[0])
                for info in socket.getaddrinfo(host, port or (443 if parsed.scheme == "https" else 80), type=socket.SOCK_STREAM)
            }
        except (OSError, ValueError) as exc:
            raise URLError(f"Could not resolve public host {host!r}: {exc}") from exc
    if not addresses or any(
        not address.is_global or address.is_multicast or address.is_reserved or address.is_unspecified
        for address in addresses
    ):
        raise URLError("Only publicly routable destinations are allowed.")


class PublicRedirectHandler(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        destination = urljoin(req.full_url, newurl)
        if urlparse(req.full_url).scheme == "https" and urlparse(destination).scheme != "https":
            raise URLError("Refusing an HTTPS-to-HTTP redirect.")
        validate_public_url(destination)
        return super().redirect_request(req, fp, code, msg, headers, destination)


def get_url(url: str) -> tuple[str, bytes, str]:
    validate_public_url(url)
    request = Request(url, headers={"User-Agent": USER_AGENT, "Accept": "text/html,text/plain,*/*;q=0.8"})
    # Avoid environment proxies that could resolve or route the host differently.
    opener = build_opener(PublicRedirectHandler(), HTTPSHandler(context=TLS_CONTEXT), ProxyHandler({}))
    with opener.open(request, timeout=TIMEOUT_SECONDS) as response:
        final_url = response.geturl()
        validate_public_url(final_url)
        content_type = response.headers.get_content_type()
        body = response.read(MAX_RESPONSE_BYTES + 1)
    if len(body) > MAX_RESPONSE_BYTES:
        body = body[:MAX_RESPONSE_BYTES]
        print("Warning: response truncated at 2 MB.", file=sys.stderr)
    return final_url, body, content_type


class SearchParser(HTMLParser):
    def __init__(self, engine: str, base_url: str):
        super().__init__(convert_charrefs=True)
        self.engine = engine
        self.base_url = base_url
        self.results: list[dict[str, str]] = []
        self.current: dict[str, str] | None = None
        self.capture: str | None = None
        self.capture_tag: str | None = None
        self.capture_text: list[str] = []
        self.result_depth = 0
        self.capture_depth = 0

    @staticmethod
    def classes(attrs: list[tuple[str, str | None]]) -> set[str]:
        return set(dict(attrs).get("class", "").split())

    def handle_starttag(self, tag: str, attrs_list: list[tuple[str, str | None]]) -> None:
        attrs = dict(attrs_list)
        classes = self.classes(attrs_list)
        if self.engine == "ddg":
            if tag == "div" and self.current is None and "result" in classes:
                self.current = {"title": "", "url": "", "snippet": ""}
                self.result_depth = 1
            elif tag == "div" and self.current is not None:
                self.result_depth += 1
            if self.current is not None and tag == "a" and "result__a" in classes:
                self.current["url"] = self.unwrap_ddg(attrs.get("href", ""))
                self.capture = "title"
                self.capture_tag = "a"
                self.capture_text = []
            elif self.current is not None and tag in ("a", "div") and "result__snippet" in classes:
                self.capture = "snippet"
                self.capture_tag = tag
                self.capture_text = []
        else:
            if tag == "div" and self.current is None and "snippet" in classes:
                self.current = {"title": "", "url": "", "snippet": ""}
                self.result_depth = 1
            elif tag == "div" and self.current is not None:
                self.result_depth += 1
            if self.current is not None and tag == "a" and attrs.get("href") and not self.current["url"]:
                self.current["url"] = urljoin(self.base_url, attrs["href"])
            if self.current is not None and tag == "div" and "search-snippet-title" in classes:
                self.current["title"] = clean_text(attrs.get("title", ""))
            if self.current is not None and tag == "div" and "content" in classes and self.capture is None:
                self.capture = "snippet"
                self.capture_tag = "div"
                self.capture_depth = 1
                self.capture_text = []
            elif self.capture == "snippet" and tag == "div":
                self.capture_depth += 1

    def handle_endtag(self, tag: str) -> None:
        if self.engine == "ddg" and self.capture and tag == self.capture_tag:
            if self.current is not None:
                self.current[self.capture] = clean_text("".join(self.capture_text))
            self.capture = None
            self.capture_tag = None
            self.capture_text = []
        elif self.engine == "brave" and self.capture == "snippet" and tag == "div":
            self.capture_depth -= 1
            if self.capture_depth == 0:
                if self.current is not None:
                    snippet = clean_text("".join(self.capture_text))
                    self.current["snippet"] = "" if "AboutPressCopyright" in snippet else snippet
                self.capture = None
                self.capture_tag = None
                self.capture_text = []
        if tag == "div" and self.current is not None:
            self.result_depth -= 1
            if self.result_depth == 0:
                if self.current["url"] and self.current["title"]:
                    self.results.append(self.current)
                self.current = None

    def handle_data(self, data: str) -> None:
        if self.capture:
            self.capture_text.append(data)

    def unwrap_ddg(self, href: str) -> str:
        absolute = urljoin(self.base_url, href)
        parsed = urlparse(absolute)
        if parsed.netloc.endswith("duckduckgo.com"):
            target = parse_qs(parsed.query).get("uddg", [None])[0]
            if target:
                return target
        return absolute


class PageTextParser(HTMLParser):
    BLOCK_TAGS = {"address", "article", "blockquote", "br", "dd", "div", "dl", "dt", "figcaption", "h1", "h2", "h3", "h4", "h5", "h6", "li", "ol", "p", "pre", "section", "table", "td", "th", "tr", "ul"}
    IGNORE_TAGS = {"script", "style", "noscript", "svg", "iframe", "form", "nav", "footer", "aside"}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []
        self.ignored = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in self.IGNORE_TAGS:
            self.ignored += 1
        elif not self.ignored and tag in self.BLOCK_TAGS:
            self.parts.append("\n")

    def handle_endtag(self, tag: str) -> None:
        if tag in self.IGNORE_TAGS and self.ignored:
            self.ignored -= 1
        elif not self.ignored and tag in self.BLOCK_TAGS:
            self.parts.append("\n")

    def handle_data(self, data: str) -> None:
        if not self.ignored:
            self.parts.append(data)


def clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", html.unescape(value)).strip()


def search(query: str, limit: int) -> int:
    engines = [
        ("ddg", "https://html.duckduckgo.com/html/?" + urlencode({"q": query})),
        ("brave", "https://search.brave.com/search?" + urlencode({"q": query, "source": "web"})),
    ]
    last_error: Exception | None = None
    for engine, url in engines:
        try:
            final_url, body, _ = get_url(url)
            page = body.decode("utf-8", errors="replace")
            if engine == "ddg" and "anomaly-modal" in page:
                continue
            parser = SearchParser(engine, final_url)
            parser.feed(page)
            results = parser.results
            if not results:
                continue
            print(f'Web search: {query}\n')
            for index, result in enumerate(results[:limit], 1):
                print(f'{index}. {result["title"]}\n   {result["url"]}')
                if result["snippet"]:
                    print(f'   {result["snippet"]}')
                print()
            return 0
        except (HTTPError, URLError, TimeoutError, OSError) as exc:
            last_error = exc
    if last_error:
        print(f"Web search failed: {last_error}", file=sys.stderr)
    else:
        print("No parseable results returned; the search page may have changed or blocked the request.", file=sys.stderr)
    return 2


def fetch(url: str, max_chars: int) -> int:
    parsed = urlparse(url)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        print("Only absolute HTTP(S) URLs are supported.", file=sys.stderr)
        return 2
    try:
        final_url, body, content_type = get_url(url)
    except (HTTPError, URLError, TimeoutError, OSError) as exc:
        print(f"Fetch failed: {exc}", file=sys.stderr)
        return 2
    if content_type in {"text/html", "application/xhtml+xml"}:
        parser = PageTextParser()
        parser.feed(body.decode("utf-8", errors="replace"))
        text = "\n".join(clean_text(part) for part in parser.parts)
        text = re.sub(r"\n[ \t]*\n+", "\n\n", text).strip()
    elif content_type.startswith("text/") or content_type == "application/json":
        text = body.decode("utf-8", errors="replace")
    else:
        print(f"Unsupported content type: {content_type}; expected HTML or text.", file=sys.stderr)
        return 2
    print(f"URL: {final_url}\nContent-Type: {content_type}\n")
    if len(text) > max_chars:
        text = text[:max_chars] + "\n\n[Output truncated; retrieve a specific section if needed.]"
    print(text)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    search_parser = commands.add_parser("search", help="Search the public web")
    search_parser.add_argument("query", help="Search terms")
    search_parser.add_argument("-n", "--limit", type=int, default=8, help="Maximum results to print (default: 8)")
    fetch_parser = commands.add_parser("fetch", help="Fetch and extract a public HTML or text page")
    fetch_parser.add_argument("url", help="Absolute HTTP(S) URL")
    fetch_parser.add_argument("--max-chars", type=int, default=12000, help="Maximum extracted characters (default: 12000)")
    args = parser.parse_args()
    if args.command == "search":
        if args.limit < 1:
            parser.error("--limit must be at least 1")
        return search(args.query, args.limit)
    if args.max_chars < 1:
        parser.error("--max-chars must be at least 1")
    return fetch(args.url, args.max_chars)


if __name__ == "__main__":
    raise SystemExit(main())
