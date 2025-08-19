#!/bin/sh
set -e

LOG=/var/log/grub-sync.log
EFI_MOUNT=${EFI_MOUNT:-/boot/efi}
TARGET_GRUB_DIR="${EFI_MOUNT}/EFI/ubuntu"
TARGET_POP_OS_GRUB_DIR="${EFI_MOUNT}/EFI/pop"

{
  echo "[$(date)] Postinst copy hook starting"

  echo "Syncing /boot/grub -> $TARGET_GRUB_DIR ..."
  mkdir -p "$TARGET_GRUB_DIR"

  sleep 30

  cp -a /boot/grub/* "$TARGET_GRUB_DIR/"
  cp /boot/grub/grub.cfg "$TARGET_POP_OS_GRUB_DIR/grub.cfg"

  echo "Copy hook done."
} >> "$LOG" 2>&1

exit 0