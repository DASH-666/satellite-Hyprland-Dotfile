#!/usr/bin/env bash
set -e

# =========================
# Default configuration variables
# =========================
TERMINAL_DEFAULT="foot"
DEFAULT_DIRECTORY="$HOME/Videos"
DEFAULT_NAME="record_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
DEFAULT_CODEC="h264_vaapi"
# DEFAULT_CODEC="h264_nvenc"
# DEFAULT_CODEC="libx264"
DEFAULT_AUDIO="alsa_output.pci-0000_00_1b.0.analog-stereo.monitor"
# =========================

TMP_FILE=$(mktemp)

# =========================
# Open terminal to get directory, file name, and audio source
# =========================
$TERMINAL_DEFAULT -e bash -c '
read -p "Enter directory to save recording (default: '"$DEFAULT_DIRECTORY"'): " OUTPUT_DIRECTORY
OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-'"$DEFAULT_DIRECTORY"'}

read -p "Enter file name (default: '"$DEFAULT_NAME"'): " FILE_NAME
FILE_NAME=${FILE_NAME:-'"$DEFAULT_NAME"'}

# List audio sources with numbers
mapfile -t SOURCES < <(pactl list sources short | awk "{print \$2}")
echo "Available audio sources:"
for i in "${!SOURCES[@]}"; do
    echo "$i) ${SOURCES[$i]}"
done

read -p "Select audio source by number (default: 0): " AUDIO_INDEX
AUDIO_INDEX=${AUDIO_INDEX:-0}
AUDIO_SOURCE=${SOURCES[$AUDIO_INDEX]}

# Save output path and audio source to temporary file
echo "$OUTPUT_DIRECTORY/$FILE_NAME|$AUDIO_SOURCE" > "'"$TMP_FILE"'"
'

# =========================
# Read values from temporary file
# =========================
INPUT=$(cat "$TMP_FILE")
rm "$TMP_FILE"
OUTPUT="${INPUT%%|*}"
AUDIO_SOURCE="${INPUT##*|}"

[[ "$OUTPUT" != *.mkv ]] && OUTPUT="$OUTPUT.mkv"

# =========================
# Notify and start recording
# =========================
echo "Recording started. Output: $OUTPUT, Audio source: $AUDIO_SOURCE"
notify-send "Screen Recording" "Recording started.\nOutput: $OUTPUT\nAudio: $AUDIO_SOURCE"

wf-recorder \
    --muxer=matroska \
    -c "$DEFAULT_CODEC" \
    --framerate=60 \
    --audio="$AUDIO_SOURCE" \
    -f "$OUTPUT" &

PID=$!
echo $PID > /tmp/wf-record.pid

echo "Recording in progress. To stop recording, run:"
echo "kill -INT $(cat /tmp/wf-record.pid)"
