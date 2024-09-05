#!/bin/bash

if [ -z "$1" ]; then
  echo '{"items": [{"title": "Error", "subtitle": "jwt <token>"}]}'
  exit 1
fi

jwt_decode() {
  local jwt="$1"
  echo "$jwt" | jq -R '
    split(".") as $parts |
    {
      header: ($parts[0] | @base64d | fromjson),
      payload: ($parts[1] | @base64d | fromjson),
      signature: $parts[2]
    } |
    .human_friendly_dates = (
      {
        exp_datetime: (if .payload.exp then (.payload.exp | localtime | strftime("%Y-%m-%dT%H:%M:%S %Z")) else empty end),
        iat_datetime: (if .payload.iat then (.payload.iat | localtime | strftime("%Y-%m-%dT%H:%M:%S %Z")) else empty end)
      } | del(.[] | select(. == null))
    )' 
}



decoded_payload=$(jwt_decode "$1")

formatted_result=$(echo "$decoded_payload" | jq -c '{
  items: [
    {
      title: (. | tostring),
      subtitle: "Copy to clipboard",
      arg: (. | tostring),
    }
  ]
}')

echo "$formatted_result"


