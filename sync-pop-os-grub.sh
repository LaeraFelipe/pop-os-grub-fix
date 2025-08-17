#!/bin/sh
set -e

LOG=/var/log/grub-sync.log
EFI_MOUNT=${EFI_MOUNT:-/boot/efi}
TARGET_DIR="${EFI_MOUNT}/EFI/ubuntu"

{
  echo "[$(date)] Postinst copy hook starting (kernel=$1 image=$2)"

  # At this point update-grub has already run in an earlier hook.
  echo "Syncing /boot/grub -> $TARGET_DIR ..."
  mkdir -p "$TARGET_DIR"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete /boot/grub/ "$TARGET_DIR/"
  else
    cp -a /boot/grub/. "$TARGET_DIR/"
  fi

  echo "Copy hook done."
} >> "$LOG" 2>&1

exit 0