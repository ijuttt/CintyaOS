if [[ -z "$WAYLAND_DISPLAY" && "$(tty)" = "/dev/tty1" ]]; then
	export XDG_SESSION_TYPE=wayland
	export XDG_SESSION_DESKTOP=wayland
	exec Hyprland
fi

#Default XDG locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

