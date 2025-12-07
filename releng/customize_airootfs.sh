#!/bin/bash
set -e

echo "[*] configuring live user..."

# Enable services
# systemctl enable seatd.service
# systemctl enable NetworkManager.service
# systemctl enable bluetooth.service

# Create groups
groupadd -f seat
groupadd -f input
groupadd -f video
groupadd -f audio
groupadd -f wheel

# Add user to groups
usermod -aG seat,input,video,audio,wheel cintya

# Remove password
passwd -d cintya

echo "[*] enabling sudo NOPASSWD for wheel group..."
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/10-cintyaos
chmod 440 /etc/sudoers.d/10-cintyaos

echo "[*] fixing ownership for /home/cintya..."
chown -R cintya:cintya /home/cintya

echo "[*] setting up permissions..."
chmod 755 /home/cintya
chmod -R 755 /home/cintya/.config 2>/dev/null || true

# Fix permissions for hypr config
if [ -d /home/cintya/.config/hypr ]; then
	chmod -R 755 /home/cintya/.config/hypr
	chmod -R +x /home/cintya/.config/hypr/scripts/*.sh 2>/dev/null || true
	chmod +x /home/cintya/.config/hypr/initial-boot.sh 2>/dev/null || true
	chmod -R +x /home/cintya/.config/hypr/UserScripts/*.sh 2>/dev/null || true
	chown -R cintya:cintya /home/cintya/.config/hypr
fi

# Fix permissions for fish config
if [ -f /home/cintya/.config/fish/config.fish ]; then
	chown cintya:cintya /home/cintya/.config/fish/config.fish
fi

echo "[*] setting up polkit for non-root users..."
mkdir -p /etc/polkit-1/rules.d
cat >/etc/polkit-1/rules.d/50-default.rules <<'POLKIT'
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
POLKIT

echo "[*] fixing wheel group entry..."
if ! grep -q "^wheel:" /etc/group; then
	echo "wheel:x:10:cintya" >>/etc/group
else
	sed -i '/^wheel:/ s/$/,cintya/' /etc/group 2>/dev/null || true
fi

echo "[*] creating wallpaper directories..."
mkdir -p /home/cintya/.config/hypr/wallpaper_effects
chown -R cintya:cintya /home/cintya/.config/hypr/wallpaper_effects

# Copy default wallpaper if exists
if [ -f /home/cintya/Pictures/Wallpapers/cintya-default.jpeg ]; then
	cp /home/cintya/Pictures/Wallpapers/cintya-default.jpeg \
		/home/cintya/.config/hypr/wallpaper_effects/.wallpaper_current
	chown cintya:cintya /home/cintya/.config/hypr/wallpaper_effects/.wallpaper_current
fi

echo "[*] creating user directories..."
su - cintya -c "xdg-user-dirs-update" 2>/dev/null || true

echo "[+] done"
