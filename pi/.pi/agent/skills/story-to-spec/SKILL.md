---
name: story-to-spec
description: Turn a user story into a project-grounded, implementation-ready spec for approval. Use when the user wants an agent-friendly plan before coding.
---

# User story to implementation spec

1. Locate the story in the conversation or a user-provided file. If it is missing or ambiguous, ask which story to use.
2. Inspect project instructions, relevant code, tests, and docs to establish the actual architecture, conventions, and likely change points. Preserve existing user changes. Resolve technical details from the repo where possible; ask about unresolved product decisions or contradictions that affect behavior.
3. Read `references/spec-format.md` and write a self-contained spec that maps every acceptance criterion to concrete behavior, likely files/components, and verification. Be specific without prescribing unrelated refactors. Do not invent file paths or leave blocking “TBD” decisions.
4. Do not modify implementation code or tests. Save only the new spec: follow an existing project convention, or use `specs/<short-slug>.md` if none exists. Never overwrite an existing file; choose a unique path or ask. If the user requests inline-only output, present it in the conversation instead.
5. Mark the document **Draft — awaiting approval**. Present the spec (and file path, if saved) and stop. Do not start implementation until the user explicitly approves it; questions or requested revisions are not approval.