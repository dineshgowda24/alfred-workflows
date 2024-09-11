#!/bin/bash

if [ -z "$1" ]; then
  echo '{"items": [{"title": "Error", "subtitle": "date <epoch>"}]}'
  exit 1
fi

EPOCH=$1
TIMEZONES=("Asia/Dubai" "Asia/Kolkata" "Asia/Riyadh" "Europe/Berlin" "UTC")


alfred_items=()

for TZ in "${TIMEZONES[@]}"; do
  date_time=$(TZ=$TZ date -r $EPOCH +"%Y-%m-%d %H:%M:%S %Z" 2> /dev/null)
  
  if [ -z "$date_time" ]; then
    continue
  fi

  alfred_items+=("{\"title\": \"$date_time\", \"subtitle\": \"$TZ\", \"arg\": \"$date_time\"}")
done

if [ ${#alfred_items[@]} -eq 0 ]; then
  echo '{"items": [{"title": "Error", "subtitle": "Invalid Epoch"}]}'
  exit 0
fi

echo "${alfred_items[@]}" | jq -s '{ items: . }'