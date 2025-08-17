#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="sync-pop-os-grub.sh"
DEST_DIR="/etc/grub.d"
DEST_FILE="$DEST_DIR/99_sync_grub"

echo "🔧 Installing post-update-grub hook..."

# Ensure source file exists
if [[ ! -f "./$SCRIPT_NAME" ]]; then
  echo "Error: Source script '$SCRIPT_NAME' not found in current directory."
  exit 1
fi

# Ensure destination directory exists
if [[ ! -d "$DEST_DIR" ]]; then
  echo "Error: Destination directory '$DEST_DIR' does not exist. Ensure that you have grub installed."
  exit 1
fi

# Copy and set permissions
cp "./$SCRIPT_NAME" "$DEST_FILE"
chmod +x "$DEST_FILE"

echo "Installation finished: $DEST_FILE"
