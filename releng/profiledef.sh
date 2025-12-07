#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="CintyaOS"
iso_label="CINTYA_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="FANBOY CINTYA GARIS KERAS <https://github.com/ijuttt/CintyaOS>"
iso_application="CintyaOS Live • Hyprland Coding Edition"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d-%H%M)"

install_dir="arch"
buildmodes=('iso')
bootmodes=(
	'bios.syslinux.eltorito'
	'bios.syslinux.disk'
	'uefi-x64.systemd-boot.esp'
	'uefi-x64.systemd-boot.eltorito'
)

arch="x86_64"
pacman_conf="pacman.conf"
packages_file="packages.x86_64"

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')

file_permissions=(
	["/etc/shadow"]="0:0:400"
	["/root"]="0:0:750"
	["/root/.automated_script.sh"]="0:0:755"
	["/root/.gnupg"]="0:0:700"
	["/usr/local/bin/choose-mirror"]="0:0:755"
	["/usr/local/bin/Installation_guide"]="0:0:755"
	["/usr/local/bin/livecd-sound"]="0:0:755"
	["/home/cintya"]="1000:1000:755"
	["/home/cintya/.config"]="1000:1000:755"
	["/home/cintya/.config/hypr/initial-boot.sh"]="1000:1000:755"
)
