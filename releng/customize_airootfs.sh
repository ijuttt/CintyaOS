#!/bin/bash
set -e

echo "[*] configuring live user..."

groupadd -f seat
groupadd -f input
groupadd -f video
groupadd -f audio
groupadd -f wheel

usermod -aG seat,input,video,audio,wheel cintya

passwd -d cintya

echo "[*] enabling sudo for wheel group..."
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "[*] fixing ownership for /home/cintya..."
chown -R cintya:cintya /home/cintya

chmod 755 /home/cintya
chmod -R 755 /home/cintya/.config
chmod -R 755 /home/cintya/.config/hypr/scripts 2>/dev/null || true
chmod +x /home/cintya/.config/hypr/initial-boot.sh 2>/dev/null || true
chmod +x /home/cintya/.config/hypr/UserScripts/*.sh 2>/dev/null || true

if [ -f /home/cintya/.config/fish/config.fish ]; then
    chown cintya:cintya /home/cintya/.config/fish/config.fish
fi

echo "[*] setting up polkit for non-root users..."
cat > /etc/polkit-1/rules.d/50-default.rules << 'POLKIT'
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
POLKIT

echo "[+] done"
