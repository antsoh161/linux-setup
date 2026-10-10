#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_CSV="$SCRIPT_DIR/../packages/packages.csv"

source /etc/os-release

case "$ID" in
  ubuntu|debian)
    COLUMN=2
    ;;
  arch)
    COLUMN=3
    ;;
  *)
    echo "Unsupported distro: $ID" >&2
    exit 1
    ;;
esac

PACKAGES=$(tail -n +2 "$PACKAGES_CSV" | grep -v '^#' | grep -v '^$' | cut -d',' -f"$COLUMN")

case "$ID" in
  ubuntu|debian)
    sudo apt-get update
    sudo apt-get install -y $PACKAGES
    ;;
  arch)
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm $PACKAGES
    ;;
esac
