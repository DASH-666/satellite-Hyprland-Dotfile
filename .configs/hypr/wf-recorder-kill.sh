#!/usr/bin/env bash

PID_FILE="/tmp/wf-record.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    kill -2 "$PID" 2>/dev/null || true
    rm "$PID_FILE"
    notify-send "Screen Recording" "Recording stopped."
else
    notify-send "Screen Recording" "No active recording found."
fi
