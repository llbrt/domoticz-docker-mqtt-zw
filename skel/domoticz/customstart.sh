#!/bin/bash

USERDATA_DIR=/opt/domoticz/userdata
echo "Custom start"
mkdir -p "$USERDATA_DIR"/scripts/dzVents/generated_scripts
mkdir -p "$USERDATA_DIR"/scripts/dzVents/data
cp -rp "$USERDATA_DIR"/files/* "$USERDATA_DIR"/../
echo "Custom start done"
