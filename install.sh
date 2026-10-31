#!/usr/bin/env bash
# Links this repo's hypr, quickshell and mako folders into ~/.config/.
#   ./install.sh         switch to this config (old folders are kept as ~/.config/<name>.old)
#   ./install.sh --undo  go back to the old config
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
names="hypr quickshell mako"

# True if ~/.config/$1 is a symlink to this repo's folder.
is_ours() {
    [ -L "$HOME/.config/$1" ] && [ "$(readlink -f "$HOME/.config/$1")" = "$repo/$1" ]
}

# -L too, so broken symlinks count as existing.
exists() {
    [ -e "$1" ] || [ -L "$1" ]
}

if [ "${1:-}" = "--undo" ]; then
    # Check everything first so nothing is half restored.
    for name in $names; do
        target="$HOME/.config/$name"
        backup="$HOME/.config/$name.old"
        if exists "$backup" && exists "$target" && ! is_ours "$name"; then
            echo "$target is not this repo's link, not restoring $backup over it." >&2
            exit 1
        fi
    done

    for name in $names; do
        target="$HOME/.config/$name"
        backup="$HOME/.config/$name.old"
        if ! is_ours "$name" && ! exists "$backup"; then
            echo "$name: not installed, skipping."
            continue
        fi
        is_ours "$name" && rm "$target"
        if exists "$backup"; then
            mv "$backup" "$target"
            echo "$name: restored old config."
        else
            echo "$name: removed link."
        fi
    done
    echo "Done. Log out and back in."
    exit 0
fi

todo=""
for name in $names; do
    if is_ours "$name"; then
        echo "$name: already installed."
    else
        todo="$todo $name"
    fi
done

if [ -z "$todo" ]; then
    echo "Already installed."
    exit 0
fi

if ! Hyprland --verify-config -c "$repo/hypr/hyprland.lua" 2>&1 | grep -q "config ok"; then
    echo "Config has errors, not installing. Run: Hyprland --verify-config -c $repo/hypr/hyprland.lua" >&2
    exit 1
fi

# Check everything first so nothing is half installed.
for name in $todo; do
    [ -d "$repo/$name" ] || { echo "$repo/$name is missing." >&2; exit 1; }
    if exists "$HOME/.config/$name" && exists "$HOME/.config/$name.old"; then
        echo "$HOME/.config/$name.old already exists, remove it first." >&2
        exit 1
    fi
done

mkdir -p "$HOME/.config"

for name in $todo; do
    target="$HOME/.config/$name"
    backup="$HOME/.config/$name.old"
    if exists "$target"; then
        mv "$target" "$backup"
        echo "Moved old $name config to $backup"
    fi
    ln -s "$repo/$name" "$target"
    echo "$name: linked."
done
echo "Installed. Log out and back in."
