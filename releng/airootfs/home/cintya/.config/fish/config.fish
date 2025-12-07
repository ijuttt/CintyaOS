# Auto start Hyprland di tty1
if status is-login
    if test -z "$WAYLAND_DISPLAY" -a (tty) = "/dev/tty1"
        set -x XDG_SESSION_TYPE wayland
        set -x XDG_SESSION_DESKTOP Hyprland
        exec Hyprland
    end
end
