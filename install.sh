#!/usr/bin/env bash
# Links this repo's Hyprland config into ~/.config/hypr.
#   ./install.sh         switch to this config (old one is kept as ~/.config/hypr.old)
#   ./install.sh --undo  go back to the old config
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
target="$HOME/.config/hypr"
backup="$HOME/.config/hypr.old"

if [ "${1:-}" = "--undo" ]; then
    [ -e "$backup" ] || { echo "No $backup to restore." >&2; exit 1; }
    [ -L "$target" ] && rm "$target"
    mv "$backup" "$target"
    echo "Restored old config. Log out and back in."
    exit 0
fi

if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$repo/hypr" ]; then
    echo "Already installed."
    exit 0
fi

if ! Hyprland --verify-config -c "$repo/hypr/hyprland.lua" 2>&1 | grep -q "config ok"; then
    echo "Config has errors, not installing. Run: Hyprland --verify-config -c $repo/hypr/hyprland.lua" >&2
    exit 1
fi

if [ -e "$target" ]; then
    [ -e "$backup" ] && { echo "$backup already exists, remove it first." >&2; exit 1; }
    mv "$target" "$backup"
    echo "Moved old config to $backup"
fi

ln -s "$repo/hypr" "$target"
echo "Installed. Log out and back in."
