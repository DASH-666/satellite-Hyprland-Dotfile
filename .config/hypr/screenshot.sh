#!/usr/bin/env bash
set -e

# =========================
# Default configuration variables
# =========================
TERMINAL_DEFAULT="foot"                             # Terminal to ask for input
DEFAULT_DIRECTORY="$HOME/Pictures"                 # Default directory to save screenshot
DEFAULT_NAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"  # Default file name
# =========================

TMP_FILE=$(mktemp)

# =========================
# Ask user for directory and file name in terminal
# =========================
$TERMINAL_DEFAULT -e bash -c '
read -p "Enter directory to save screenshot (default: '"$DEFAULT_DIRECTORY"'): " OUTPUT_DIRECTORY
OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-'"$DEFAULT_DIRECTORY"'}

read -p "Enter file name (default: '"$DEFAULT_NAME"'): " FILE_NAME
FILE_NAME=${FILE_NAME:-'"$DEFAULT_NAME"'}

# Save full path to temporary file
echo "$OUTPUT_DIRECTORY/$FILE_NAME" > "'"$TMP_FILE"'"
'

# =========================
# Read path and clean up
# =========================
DEST=$(cat "$TMP_FILE")
rm "$TMP_FILE"

# Ensure .png extension
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
