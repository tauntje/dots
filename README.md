# Dotfiles

Personal configuration for a keyboard-focused development environment. The repository covers Linux desktops and shells, terminal applications, Neovim, tmux, Visual Studio Code, and selected Windows and macOS tools.

Configurations are organized as [GNU Stow](https://www.gnu.org/software/stow/) packages. Install the programs you plan to use, then stow their package directories from the repository root.

## Contents

| Package or file | Purpose |
| --- | --- |
| `bash/`, `zsh/` | Shell startup files, aliases, functions, and integrations |
| `starship/` | Starship prompt configuration |
| `nvim/` | Neovim configuration and plugin lock file |
| `tmux/` | Tmux configuration and TPM plugins |
| `kitty/`, `alacritty/`, `ghostty/` | Terminal emulator configuration |
| `sway/`, `waybar/`, `wofi/`, `wallpapers/` | Sway desktop configuration and assets |
| `aerospace/` | AeroSpace configuration for macOS |
| `vsCodeJson/` | Visual Studio Code settings and keybindings |
| `.ideavimrc` | IdeaVim configuration for JetBrains IDEs |
| `gnome_settings.dconf` | GNOME settings snapshot for reference or import |

## Linux setup

The commands below target Debian 13. Package names may differ on other distributions.

### 1. Install the command-line tools

Install the Debian-packaged tools and basic dependencies:

```bash
sudo apt update
sudo apt install -y build-essential curl fonts-jetbrains-mono fzf git gpg jq kitty \
  lazygit pipx podman podman-compose python3 ripgrep starship stow tmux unzip wget zsh
```

This installs Debian-packaged shell, search, Git, container, and Python tools, plus JetBrains Mono. `build-essential` provides GCC and Make. The upstream instructions below install Carapace, eza, and zoxide separately. Install additional desktop or terminal applications only if you use their configurations.

### 1a. Install Carapace, eza, and zoxide

Carapace publishes Debian packages with its [GitHub releases](https://github.com/carapace-sh/carapace-bin/releases). The following fetches the latest Linux AMD64 `.deb` and installs it:

```bash
asset="$(curl -fsSL https://api.github.com/repos/carapace-sh/carapace-bin/releases/latest \
  | jq -er '.assets[].browser_download_url | select(test("carapace-bin_[^/]+_linux_amd64\\.deb$"))')"
curl -fLO "$asset"
sudo apt install "./${asset##*/}"
```

For a different architecture, download the matching `.deb` from the releases page. Carapace's [installation guide](https://carapace-sh.github.io/carapace-bin/install.html) also documents its Fury repository and other installation methods.

The eza project recommends its signed Debian repository. These commands follow the [upstream Debian instructions](https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu):

```bash
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
  | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
```

For zoxide, upstream recommends its installer on Debian-based systems because distro packages can lag behind:

```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

The installer places zoxide in `~/.local/bin`, which is added to `PATH` by the supplied shell configs.

### 2. Install Neovim

Neovim is installed from its official Linux archive under `/opt`; the shell configs add it to `PATH`:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

### 3. Link the core dotfiles

From the root of this repository, stow the core shell and editor configuration:

```bash
stow zsh starship nvim
```

Stow only the terminal package you use: `stow kitty`, `stow alacritty`, or `stow ghostty`. Stow the Tmux config separately with `stow tmux`. If a destination file already exists and is not managed by Stow, back it up and merge its contents before stowing; otherwise Stow will report a conflict.

The Zsh config initializes Starship, Carapace, zoxide, and Atuin. It also provides the `ls`/`ll` aliases, vi-style command editing, `mkcd`, and the `fcd`, `fim`, and `ifzf` helpers. The latter three require `fzf`; `ifzf` also requires Kitty's `kitten` command and a Kitty-compatible terminal session.

### 4. Install Atuin and Node.js

Atuin is installed under `~/.atuin/bin`. Its setup script creates the environment file loaded by `zsh/.zshrc`, and installs the Zsh integration already configured there:

```bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

The installer can import existing shell history. Atuin sync is optional; local history search works without creating an account.

Install nvm and the current Node.js LTS release:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install --lts
```

### 5. Make Zsh the login shell

If Zsh is not already the account's login shell, set it once after installing the `zsh` package:

```bash
chsh -s "$(command -v zsh)"
```

Log out and start a new session. If a terminal profile explicitly launches Bash, change that profile to start the default login shell instead.

## Shell utilities

The Zsh startup file in `zsh/.zshrc` configures the following tools:

| Utility | Use | Setup |
| --- | --- | --- |
| [Starship](https://starship.rs/) | Prompt; the prompt symbol is set in `starship/.config/starship.toml` | `apt install starship`; `stow starship` (supported on Debian 13+) |
| [Carapace](https://github.com/carapace-sh/carapace-bin) | Command completions | Install the latest GitHub `.deb` as described above |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Frecency-based directory navigation; use `z <query>` or `zi` | Run the upstream installer above |
| [Atuin](https://atuin.sh/) | Searchable shell history; press `Ctrl-R` | Run the Atuin setup command above |
| [eza](https://github.com/eza-community/eza) | Modern `ls`; exposed as `ls` and `ll` aliases | Add the signed upstream Debian repository as described above |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy selection for shell helper functions | `apt install fzf` (upstream supports Debian 9+) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast text search (`rg`) | `apt install ripgrep` (Debian stable package; upstream releases also provide `.deb` files) |
| [jq](https://github.com/jqlang/jq) | JSON processing | `apt install jq` (official Debian package) |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal Git interface | `apt install lazygit` (supported on Debian 13+) |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer | `apt install tmux` |
| [Podman](https://podman.io/) and [podman-compose](https://github.com/containers/podman-compose) | Container runtime and Compose workflow | `apt install podman podman-compose` (both documented by upstream for Debian) |
| nvm, Node.js, npm | Per-user Node.js version management | Install nvm, then `nvm install --lts` |
| Python 3 and pipx | Python and isolated command-line applications | `apt install python3 pipx` |

zoxide and Atuin are initialized in the repository's Zsh config. If you use Bash instead, add the corresponding shell initializers to `bash/.bashrc` before stowing it; the supplied Bash file currently initializes Starship and nvm.

## Fonts

JetBrains Mono is the configured monospace font for the terminal emulators, Waybar, Wofi, Visual Studio Code, and GNOME's monospace preference.

Install JetBrains Mono from Debian:

```bash
sudo apt install fonts-jetbrains-mono
```

Set it as GNOME's default monospace font (also recorded in `gnome_settings.dconf`):

```bash
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'
```

Refresh the font cache after installing fonts if an application does not pick up the new family:

```bash
fc-cache -f
```

The regular JetBrains Mono package does not include Nerd Font private-use icons. If terminal symbols are missing, install a Nerd Font-patched JetBrains Mono family separately; the text family configured here remains `JetBrains Mono`.

## GNOME desktop

The GNOME setup is intentionally light-touch and relies on GNOME defaults. Install Tweaks and Dconf Editor for the settings described below:

```bash
sudo apt install gnome-tweaks dconf-editor
```

### Dconf backup and restore

The repository includes `gnome_settings.dconf` as a reference snapshot. From the repository root, export a new snapshot with:

```bash
dconf dump / > gnome_settings.dconf
```

Restore a snapshot with:

```bash
dconf load -f / < gnome_settings.dconf
```

Review a snapshot before importing it on another machine: it can contain machine-specific preferences and file paths. The manual settings below are the more predictable option when a full import is unsuitable.

### Workspaces and keybindings

Create eight workspaces:

```bash
gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
```

In Dconf Editor, under `org/gnome/shell/keybindings`, clear `switch-to-application-1` through `switch-to-application-9` to free the Super-number shortcuts. Then configure:

- `org/gnome/desktop/wm/keybindings/switch-to-workspace-N` as `['<Super>N']`.
- `org/gnome/desktop/wm/keybindings/move-to-workspace-N` as `['<Shift><Super>N']`.

Replace `N` with the workspace number. Super is the primary window-management key; other GNOME settings remain close to their defaults.

## Sway desktop (optional)

The repository also contains a Sway, Waybar, and Wofi setup. Install the main components and screenshot dependencies:

```bash
sudo apt install sway waybar wofi grim slurp wl-clipboard
```

Then link the configuration and wallpaper packages:

```bash
stow sway waybar wofi wallpapers
```

The Sway config launches Kitty, Waybar, and Wofi, uses `jq` for a screenshot binding, and expects the `grim`, `slurp`, and `wl-copy` commands. Install Kitty as well if it is not already installed. The Wofi scripts may require the corresponding NetworkManager and audio utilities on the target system.

## Tmux

Install the Tmux Plugin Manager (TPM):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and press the prefix key followed by `I` to install plugins. The default prefix is `Ctrl-B`. Press prefix then `r` to reload `~/.tmux.conf`. The config uses Vim-style pane navigation, mouse support, Catppuccin styling, and TPM plugins.

## Visual Studio Code

The `vsCodeJson/` directory contains editor settings and keybindings. Copy or merge them into the VS Code user configuration directory for the current operating system.

Configured preferences include format-on-save, a Catppuccin Macchiato color theme and icons, JetBrains Mono, Vim keybindings, and custom terminal/editor shortcuts. Install Catppuccin for VS Code for the selected appearance. Other extensions recorded in the setup are:

- Live Server
- Material Icon Theme
- One Dark Pro (alternative theme)
- Prettier
- Vim

## Windows and JetBrains IDEs

The root `.ideavimrc` contains IdeaVim mappings and IntelliJ actions. Place it at `%USERPROFILE%\.ideavimrc` on Windows and install these JetBrains plugins:

- IdeaVim
- PokeProgress
- Atom One Dark theme and Material icons
- Harpooner

The original setup notes also referred to a standalone Vim `_vimrc`, but no `_vimrc` is present in this checkout. Add one on Windows if you use standalone Vim; `.ideavimrc` is for JetBrains IDEs.

## macOS and AeroSpace

The `aerospace/` directory contains a keyboard-driven AeroSpace layout configuration. AeroSpace expects its main configuration at `~/.aerospace.toml`; copy the repository file into place:

```bash
cp aerospace/.config/aerospace/aerospace.toml ~/.aerospace.toml
```

## Applying other Stow packages

Any directory laid out with paths relative to `$HOME` can be managed as a Stow package. From the repository root, run:

```bash
stow <package>
```

For example, `stow nvim` links the Neovim config to `~/.config/nvim`. Install the corresponding application before enabling its package.
