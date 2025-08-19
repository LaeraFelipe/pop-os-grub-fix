#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="handle-grub-change.sh"
SERVICE_NAME="grub-monitor.service"
PATH_UNIT_NAME="grub-monitor.path"

DEST_SCRIPT_FILE="/usr/local/bin/handle-grub-change.sh"
DEST_SERVICE_FILE="/etc/systemd/system/grub-monitor.service"
DEST_PATH_UNIT_FILE="/etc/systemd/system/grub-monitor.path"


echo "Installing post-update-grub hook..."

cp "./$SCRIPT_NAME" "$DEST_SCRIPT_FILE"
chmod +x "$DEST_SCRIPT_FILE"

cp "./$SERVICE_NAME" "$DEST_SERVICE_FILE"
cp "./$PATH_UNIT_NAME" "$DEST_PATH_UNIT_FILE"

sudo systemctl daemon-reload
sudo systemctl enable --now grub-monitor.path


echo "Installation finished"
