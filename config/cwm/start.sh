#!/usr/bin/env bash
xset r rate 200 50 &
if command -v systemctl --user >/dev/null 2>&1; then
    systemctl --user import-environment DISPLAY XAUTHORITY
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
fi
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx
xsetroot -solid "#1E1B25"
~/.config/cwm/bar.sh &
fcitx5 &
copyq &
# xrandr --output DP-2 --mode 1920x1080 --rate 144.00
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export __NV_PRIME_RENDER_OFFLOAD=1
exec cwm -c ~/.config/cwm/config
