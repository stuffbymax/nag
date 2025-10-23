#!/bin/bash
# Arch Linux: Full system directory permission recovery
# Run as root (rescue mode or chroot)

echo "[*] Fixing root directory..."
chmod 700 /root
chown root:root /root

echo "[*] Fixing /tmp..."
chmod 1777 /tmp
chown root:root /tmp

echo "[*] Fixing top-level system directories..."
dirs=(/ /bin /sbin /usr /lib /lib64 /etc /var /opt /srv /boot /run /root)
for d in "${dirs[@]}"; do
    if [ -d "$d" ]; then
        chmod 755 "$d"
        chown root:root "$d"
    fi
done

echo "[*] Fixing home directories..."
users=(zdi ftpuser)
for user in "${users[@]}"; do
    if [ -d "/home/$user" ]; then
        chmod 700 /home/$user
        chown $user:$user /home/$user
        echo "[*] Fixed /home/$user"
    fi
done

echo "[*] Restoring package-managed file permissions..."
read -p "Do you want to reinstall all native packages to restore permissions? (y/N): " reinstall
if [[ "$reinstall" =~ ^[Yy]$ ]]; then
    pacman -Qnq | pacman -S --needed -
fi

echo "[*] Done. You can now reboot the system."
