#!/bin/bash

STATE_FILE="/tmp/wifi_state.txt"

set_wifi_state() {
  if [ "$1" = "off" ]; then
    rfkill block 0 1 2 3 4 5 6 7 8 9
    notify-send " WiFi & BlueTooth off"
  else
    rfkill unblock 0 1 2 3 4 5 6 7 8 9
    notify-send " WiFi & BlueTooth on"
  fi
  echo "$1" > "$STATE_FILE"
}

if [ -f "$STATE_FILE" ]; then
  WIFI_STATE=$(cat "$STATE_FILE")
else
  WIFI_STATE="off"
fi

if [ "$WIFI_STATE" = "off" ]; then
  set_wifi_state "on"
else
  set_wifi_state "off"
fi

echo "WiFi state: $(cat "$STATE_FILE")"
