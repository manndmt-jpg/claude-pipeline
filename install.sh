#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

echo "claude-pipeline installer"
echo "========================="
echo ""

# Ensure target directory exists
mkdir -p "$COMMANDS_DIR"

# Commands to install
COMMANDS=("plan" "implement" "pre-pr" "code-review")

installed=0
backed_up=0
skipped=0

for cmd in "${COMMANDS[@]}"; do
    source="$SCRIPT_DIR/commands/$cmd.md"
    target="$COMMANDS_DIR/$cmd.md"

    if [ ! -f "$source" ]; then
        echo "  SKIP  $cmd.md — source not found at $source"
        ((skipped++))
        continue
    fi

    # If target exists and is NOT a symlink to us, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup="$target.backup"
        echo "  BACKUP  $cmd.md → $cmd.md.backup"
        cp "$target" "$backup"
        ((backed_up++))
    elif [ -L "$target" ]; then
        current_link="$(readlink "$target")"
        if [ "$current_link" = "$source" ]; then
            echo "  OK    $cmd.md — already linked"
            ((installed++))
            continue
        else
            echo "  RELINK  $cmd.md — was pointing to $current_link"
        fi
    fi

    # Create symlink
    ln -sf "$source" "$target"
    echo "  LINKED  $cmd.md → $source"
    ((installed++))
done

echo ""
echo "Done."
echo "  Linked: $installed"
echo "  Backed up: $backed_up"
echo "  Skipped: $skipped"
echo ""
echo "Commands available: /plan, /implement, /pre-pr, /code-review"
