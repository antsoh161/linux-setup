#!/usr/bin/env bash
set -euo pipefail

NVIM_CONFIG_REPO="https://github.com/antsoh161/nvim"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET="$CONFIG_HOME/nvim"

mkdir -p "$CONFIG_HOME"

if [ -d "$TARGET/.git" ]; then
  git -C "$TARGET" pull
else
  git clone "$NVIM_CONFIG_REPO" "$TARGET"
fi
