#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/antsoh161/dotfiles"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup}"

dot() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

if [ ! -d "$DOTFILES_DIR" ]; then
  git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

CHECKOUT_ERR="$(mktemp)"
if ! dot checkout 2>"$CHECKOUT_ERR"; then
  mkdir -p "$BACKUP_DIR"
  grep -E '^\s+\S+' "$CHECKOUT_ERR" | awk '{print $1}' | while read -r file; do
    mkdir -p "$BACKUP_DIR/$(dirname "$file")"
    mv "$HOME/$file" "$BACKUP_DIR/$file"
  done
  dot checkout
fi
rm -f "$CHECKOUT_ERR"

dot config --local status.showUntrackedFiles no
