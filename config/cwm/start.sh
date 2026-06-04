#!/usr/bin/env bash

# 1. Environment & Inputs
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx

# 2. D-Bus Environment Handlers
launch_cwm() {
    # Update the variables inside the newly created D-Bus session
    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XMODIFIERS GTK_IM_MODULE QT_IM_MODULE SDL_IM_MODULE GLFW_IM_MODULE
    fi

    # Start portals inside the active D-Bus session
    /usr/libexec/xdg-desktop-portal-gtk &
    /usr/libexec/xdg-desktop-portal &

    xsetroot -solid "#1E1B25"
    xset r rate 200 50 &
    fcitx5 &
    gentoo-pipewire-launcher &

    # Spawn Window Manager
    exec cwm -c ~/.config/cwm/config
}

# 3. Initialize D-Bus and run the function
exec dbus-run-session bash -c "$(declare -f launch_cwm); launch_cwm"
