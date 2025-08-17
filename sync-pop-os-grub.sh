#!/bin/sh
set -e

LOG=/var/log/grub-sync.log
EFI_MOUNT=${EFI_MOUNT:-/boot/efi}
TARGET_DIR="${EFI_MOUNT}/EFI/ubuntu"

{
  echo "[$(date)] Postinst copy hook starting"

  echo "Syncing /boot/grub -> $TARGET_DIR ..."
  mkdir -p "$TARGET_DIR"

  cp -a /boot/grub/* "$TARGET_DIR/"

  echo "Copy hook done."
} >> "$LOG" 2>&1

exit 0