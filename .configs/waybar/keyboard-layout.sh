#!/bin/bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

case "$layout" in
    "English (US)") echo "EN" ;;
    "Persian") echo "FA" ;;
    *) echo "$layout" ;;
esac
