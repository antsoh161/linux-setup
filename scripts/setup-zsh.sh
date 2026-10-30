#!/usr/bin/env bash
set -euo pipefail

OMZ_REPO="https://github.com/ohmyzsh/ohmyzsh"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"
CATPPUCCIN_URL="https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/7926c3d3e17d26b3779851a2255b95ee650bd928/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

if ! command -v zsh >/dev/null; then
  echo "zsh not found; run scripts/install-packages.sh first" >&2
  exit 1
fi

# Clones $1 into $2, or pulls if it's already there.
clone_or_pull() {
  if [ -d "$2/.git" ]; then
    git -C "$2" pull
  else
    git clone "$1" "$2"
  fi
}

# Cloned directly instead of using the upstream installer so the .zshrc from
# the dotfiles repo is left alone.
clone_or_pull "$OMZ_REPO" "$ZSH_DIR"

mkdir -p "$ZSH_CUSTOM/plugins" "$HOME/.zsh/themes"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/sindresorhus/pure "$HOME/.zsh/pure"

curl -fLo "$HOME/.zsh/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" "$CATPPUCCIN_URL"

ZSH_PATH="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]; then
  sudo chsh -s "$ZSH_PATH" "$USER"
fi
