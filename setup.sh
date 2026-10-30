#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

confirm() {
  local reply
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

if confirm "Install packages (apt/pacman, see packages/packages.csv)?"; then
  "$SCRIPT_DIR/scripts/install-packages.sh"
fi

if confirm "Build/install from source (neovim, noctalia-shell - tags pinned in versions.env)?"; then
  "$SCRIPT_DIR/scripts/build-from-source.sh"
fi

if confirm "Install dotfiles (clone antsoh161/dotfiles bare repo into \$HOME)?"; then
  "$SCRIPT_DIR/scripts/setup-dotfiles.sh"
fi

if confirm "Set up zsh (oh-my-zsh, plugins, pure prompt, set as login shell)?"; then
  "$SCRIPT_DIR/scripts/setup-zsh.sh"
fi

if confirm "Clone nvim config (antsoh161/nvim) into \$XDG_CONFIG_HOME/nvim?"; then
  "$SCRIPT_DIR/scripts/setup-nvim-config.sh"
fi

if confirm "Install tmux plugin manager (tpm) into \$XDG_CONFIG_HOME/tmux/plugins/tpm?"; then
  "$SCRIPT_DIR/scripts/setup-tpm.sh"
fi

if confirm "Install nvm (into \$NVM_DIR, default ~/.nvm) and the latest Node LTS?"; then
  "$SCRIPT_DIR/scripts/setup-nvm.sh"
fi

