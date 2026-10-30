#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_FILE="$SCRIPT_DIR/../repos/repos.txt"
VERSIONS_FILE="$SCRIPT_DIR/../versions.env"
SRC_DIR="${SRC_DIR:-$HOME/src}"

mkdir -p "$SRC_DIR"

# Looks up "name=tag" in versions.env; empty if the repo has no pinned tag.
tag_for() {
  grep -E "^$1=" "$VERSIONS_FILE" 2>/dev/null | head -1 | cut -d'=' -f2-
}

confirm() {
  local reply
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# Rows are read on fd 3 so the per-repo confirm() can still read from stdin.
while IFS='|' read -r -u 3 name url build_cmd install_cmd; do
  [ -z "$name" ] && continue

  if ! confirm "Build/install $name ($url)?"; then
    echo ">>> Skipping $name"
    continue
  fi

  target="$SRC_DIR/$name"
  tag="$(tag_for "$name")"

  if [ -d "$target/.git" ]; then
    git -C "$target" fetch --tags
  else
    git clone "$url" "$target"
  fi

  if [ -n "$tag" ]; then
    git -C "$target" checkout "$tag"
  fi

  echo ">>> Building $name${tag:+ ($tag)}"
  (cd "$target" && eval "$build_cmd" && eval "$install_cmd")
done 3< <(tail -n +2 "$REPOS_FILE" | grep -v '^#' | grep -v '^$')
