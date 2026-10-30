#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSIONS_FILE="$SCRIPT_DIR/../versions.env"
NVM_REPO="https://github.com/nvm-sh/nvm"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

tag="$(grep -E '^nvm=' "$VERSIONS_FILE" 2>/dev/null | head -1 | cut -d'=' -f2-)"

if [ -d "$NVM_DIR/.git" ]; then
  git -C "$NVM_DIR" fetch --tags
else
  git clone "$NVM_REPO" "$NVM_DIR"
fi

if [ -n "$tag" ]; then
  git -C "$NVM_DIR" checkout "$tag"
fi

# nvm.sh isn't written for set -u.
set +u
# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"
nvm install --lts
