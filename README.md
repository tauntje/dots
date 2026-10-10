# Dots

Personal configuration for a keyboard-focused development environment. The repository covers Linux desktops and shells, terminal applications, Neovim, herdr, Visual Studio Code, and selected Windows and macOS tools.

Configurations are organized as [GNU Stow](https://www.gnu.org/software/stow/) packages. Install the programs you plan to use, then stow their package directories from the repository root.

## Linux setup

The commands below target Debian 13. Package names may differ on other distributions.

### 1. Install the command-line tools

Install the Debian-packaged tools and basic dependencies:

```bash
sudo apt update
sudo apt install -y build-essential curl fzf git gpg jq \
  lazygit pipx podman podman-compose python3 ripgrep stow tmux unzip wget zsh
```

This installs Debian-packaged shell, search, Git, container, and Python tools.  `build-essential` provides GCC and Make. Other essentials CLI tools instruction below.

#### Install Carapace, eza, and zoxide

| Utility |
| --- |
| [Starship](https://starship.rs/) |
| [Carapace](https://github.com/carapace-sh/carapace-bin) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) |
| [Atuin](https://atuin.sh/) |
| [eza](https://github.com/eza-community/eza) |
| [fzf](https://github.com/junegunn/fzf) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) |
| [jq](https://github.com/jqlang/jq) |
| [lazygit](https://github.com/jesseduffield/lazygit) |
| [tmux](https://github.com/tmux/tmux) |
| [Podman](https://podman.io/) and [podman-compose](https://github.com/containers/podman-compose) |
| nvm, Node.js, npm |
| Python 3 and pipx |

## Fonts

Hack Nerd Mono is the configured monospace font for the terminal emulators, Waybar, Wofi, Visual Studio Code, and GNOME's monospace preference.

Get it from [Nerf font aggregator](https://www.nerdfonts.com/font-downloads), add it to `~/.local/share/fonts/` and run `sudo fc-cache -fv` to update it.

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

### Workspaces and keybindings

Create eight workspaces:

```bash
gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
```

In Dconf Editor, under `org/gnome/shell/keybindings`, clear `switch-to-application-1` through `switch-to-application-9` to free the Super-number shortcuts. Then configure:

- `org/gnome/desktop/wm/keybindings/switch-to-workspace-N` as `['<Super>N']`.
- `org/gnome/desktop/wm/keybindings/move-to-workspace-N` as `['<Shift><Super>N']`.

Replace `N` with the workspace number. Super is the primary window-management key; other GNOME settings remain close to their defaults.

## macOS and AeroSpace

The `aerospace/` directory contains a keyboard-driven AeroSpace layout configuration. AeroSpace expects its main configuration at `~/.aerospace.toml`; copy the repository file into place:

```bash
stow aerospace
```
