#!/bin/bash

LAUNCH_DIR=$(dirname "$0")
CFG_FILE="$LAUNCH_DIR"/configuration.cfg
SRC_DIR="$LAUNCH_DIR"/skel
DEST_DIR="$LAUNCH_DIR"/_domoticz

cp -rp "$SRC_DIR" "$DEST_DIR"

grep '=' "$CFG_FILE" | sed 's/=/ /'  | while read -r key value
do
	find "$DEST_DIR" -type f -exec sed -i "s%$key%$value%g" '{}' \;
done

