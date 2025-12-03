#!/bin/bash
set -e

echo "[*] configuring live user..."

# Pastikan group ada (kalau belum)
groupadd -f seat
groupadd -f input
groupadd -f video
groupadd -f audio

# Masukin user ke group device
usermod -aG seat,input,video,audio cintya

# Permission home
chown -R cintya:cintya /home/cintya

# Autologin safety
passwd -d cintya

echo "[+] done"
