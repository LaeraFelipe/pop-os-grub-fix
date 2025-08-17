# README — Pop!\_OS GRUB Fix

A small utility that fixes common GRUB issues on Pop!\_OS by installing GRUB (UEFI), wiring a post-update hook, and syncing the generated config to your EFI partition.

> ⚠️ **Use at your own risk.** Back up important data first. Tested on Pop!\_OS 22.04+ with UEFI systems.

---

## 1) Download this repository

```bash
# Install git if needed
sudo apt update && sudo apt install -y git

# Clone the repo
git clone https://github.com/LaeraFelipe/pop-os-grub-fix.git
cd pop-os-grub-fix
```
---

## 2) Requirements

* Pop!\_OS on a **UEFI** system (not Legacy/CSM).
* An EFI System Partition (ESP), typically mounted at `/boot/efi`.
* Internet access to install packages.

Verify mounts:

```bash
mount | grep -E "/boot|efi"
```

If `/boot/efi` is not mounted, mount it before continuing.

---

## 3) Install GRUB (UEFI) on Pop!\_OS

Pop!\_OS uses systemd-boot by default. These steps install GRUB and generate its config.

```bash
# Install GRUB packages for UEFI
sudo apt update
sudo apt install -y grub-efi-amd64 shim-signed

# Ensure the ESP is present
sudo mkdir -p /boot/efi

# Install GRUB to the EFI (adjust --efi-directory if yours differs)
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=pop

# Generate GRUB configuration
sudo update-grub
```
---

## 4) Run the installer (this repo)

The script sets up a post-update hook (`/etc/grub.d/99_sync_grub`) so every `update-grub` automatically syncs the generated config into your EFI path (e.g., `/boot/efi/EFI/pop/` or `/boot/efi/EFI/ubuntu/`), avoiding the “GRUB minimal shell” and stale config issues.

```bash
# From inside the cloned repo folder:
chmod +x ./install.sh
sudo ./install.sh
```

What the installer does:

* Creates or updates `/etc/grub.d/99_sync_grub` (executable).
* After each `update-grub`, copies the fresh config and assets into the EFI GRUB directory.
* Optionally logs to `/var/log/grub-sync.log`.

---

## 5) Reboot and test

```bash
sudo update-grub
sudo reboot
```

You should now boot straight into the GRUB menu (or your default OS) without dropping to the minimal prompt.

---

## Uninstall

```bash
sudo rm -f /etc/grub.d/99_sync_grub
sudo update-grub
```

If you also want to remove GRUB entirely and return to systemd-boot, follow System76’s official guidance for restoring systemd-boot (outside the scope of this repo).

---

## Troubleshooting

* **Minimal GRUB shell** at boot:

  * Boot once using manual commands, then inside the OS run `sudo update-grub` and confirm the EFI folder contains updated files:

    ```bash
    sudo ls -l /boot/efi/EFI/{pop,ubuntu}/
    ```
* **Wrong EFI vendor folder**:

  * Reinstall with the desired ID:

    ```bash
    sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu
    sudo update-grub
    ```
* **Secure Boot**:

  * If Secure Boot is enabled, prefer `shim-signed`. If custom kernels/modules are used, you may need to sign them or disable Secure Boot.
* **Logs**:

  * Check `/var/log/grub-sync.log` (if enabled by the script) or run:

    ```bash
    sudo bash -x /etc/grub.d/99_sync_grub
    ```

---

## Directory layout (repo)

```
popos-grub-fix/
├─ install.sh                 # Main installer (run as root)
├─ 99_sync_grub               # Hook to sync grub files    
└─ README.md
```

---

## License

MIT — see `LICENSE`.
