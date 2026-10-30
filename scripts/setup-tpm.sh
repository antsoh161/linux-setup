#!/usr/bin/env bash
set -euo pipefail

TPM_REPO="https://github.com/tmux-plugins/tpm"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET="$CONFIG_HOME/tmux/plugins/tpm"

mkdir -p "$(dirname "$TARGET")"

if [ -d "$TARGET/.git" ]; then
  git -C "$TARGET" pull
else
  git clone "$TPM_REPO" "$TARGET"
fi
