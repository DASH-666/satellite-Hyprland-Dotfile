#!/usr/bin/env bash
set -e

# =========================
# Default configuration variables
# =========================
TERMINAL_DEFAULT="foot"
DEFAULT_DIRECTORY="$HOME/Pictures"
DEFAULT_NAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
# =========================

AUTO_MODE=false

# Parse arguments
while getopts "a" opt; do
    case $opt in
        a)
            AUTO_MODE=true
            ;;
        *)
            exit 1
            ;;
    esac
done

if $AUTO_MODE; then
    mkdir -p "$DEFAULT_DIRECTORY"

    DEST="$DEFAULT_DIRECTORY/$DEFAULT_NAME"

    # Fullscreen screenshot
    grim "$DEST"

    notify-send "📸 Screenshot saved" "Saved to: $DEST"
    echo "Screenshot saved: $DEST"
    exit 0
fi

TMP_FILE=$(mktemp)

# =========================
# Ask user for directory and file name in terminal
# =========================
$TERMINAL_DEFAULT -e bash -c '
read -p "Enter directory to save screenshot (default: '"$DEFAULT_DIRECTORY"'): " OUTPUT_DIRECTORY
OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-'"$DEFAULT_DIRECTORY"'}

read -p "Enter file name (default: '"$DEFAULT_NAME"'): " FILE_NAME
FILE_NAME=${FILE_NAME:-'"$DEFAULT_NAME"'}

echo "$OUTPUT_DIRECTORY/$FILE_NAME" > "'"$TMP_FILE"'"
'

# =========================
# Read path and clean up
# =========================
DEST=$(cat "$TMP_FILE")
rm "$TMP_FILE"

mkdir -p "$(dirname "$DEST")"

[[ "$DEST" != *.png ]] && DEST="$DEST.png"

# =========================
# Select region and take screenshot
# =========================
REGION=$(slurp) || exit

grim -g "$REGION" "$DEST"

# =========================
# Notify user
# =========================
notify-send "📸 Screenshot saved" "Saved to: $DEST"

echo "Screenshot saved: $DEST"
