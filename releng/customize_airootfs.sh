#!/bin/bash
set -e

echo "[*] configuring live user..."

# Pastikan group ada
groupadd -f seat
groupadd -f input
groupadd -f video
groupadd -f audio

# Masukin user ke group device
usermod -aG seat,input,video,audio,wheel cintya

# Set password kosong buat auto-login
passwd -d cintya

# CRITICAL: Fix ownership semua file di home cintya
echo "[*] fixing ownership for /home/cintya..."
chown -R cintya:cintya /home/cintya

# Fix permission
chmod 755 /home/cintya
chmod -R 755 /home/cintya/.config
chmod -R 755 /home/cintya/.config/hypr/scripts
chmod +x /home/cintya/.config/hypr/initial-boot.sh 2>/dev/null || true
chmod +x /home/cintya/.config/hypr/UserScripts/*.sh 2>/dev/null || true

# Fix fish config
if [ -f /home/cintya/.config/fish/config.fish ]; then
	chown cintya:cintya /home/cintya/.config/fish/config.fish
fi

echo "[+] done"
