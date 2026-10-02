# Keep the PATH entries unique and make the user-installed tools available.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/bin" /opt/nvim-linux-x86_64/bin "$HOME/.opencode/bin" $path)
[[ -d /usr/local/go/bin ]] && path=(/usr/local/go/bin $path)
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)
export PATH

# Match the vi-style command-line editing from Bash.
bindkey -v

alias cdn='cd -- "$HOME/Documents/notes"'
alias vim='nvim'
alias v='nvim' # The old AppImage target under ~/.local/share/applications is absent.
alias ll='eza -Ahl --icons'
alias ls='eza -hl --icons'

export EDITOR=nvim
export VISUAL=nvim

mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

fcd() {
  local dir
  dir=$(find . -type d -print 2>/dev/null | fzf) || return
  [[ -n "$dir" ]] && cd -- "$dir"
}

fim() {
  local file
  file=$(find . -type f -print 2>/dev/null | fzf) || return
  [[ -n "$file" ]] && "$EDITOR" "$file"
}

ifzf() {
  local file
  file=$(find . -type f -print 2>/dev/null | fzf) || return
  [[ -n "$file" ]] && kitten icat "$file"
}

# nvm is loaded from the same location as in Bash; Bash-only completion is omitted.
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Carapace provides the command completions configured in the Bash startup file.
if command -v carapace >/dev/null 2>&1; then
  autoload -Uz compinit
  compinit
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  source <(carapace _carapace zsh)
fi

# Starship uses the repo's ~/.config/starship.toml after `stow starship`.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

eval "$(zoxide init zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
