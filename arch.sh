#!/usr/bin/env sh

# Exit on unset variables
set -u

LOG_FILE="$HOME/.local/state/pkg_install.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Package Categorization
DEV_CORE="git neovim openssh stylua opencode"
SYS_HW="bluetuith brightnessctl lm_sensors playerctl podman pulsemixer tailscale"
CLI_UTIL="bat bottom fastfetch fd fzf ncdu ripgrep stow tmux yazi"
ARCHIVES="p7zip unrar unzip zip"
XORG_WM="cwm copyq flameshot lemonbar-xft nwg-look slock xclip xdg-desktop-portal-gtk xorg"
INPUT_FONT="fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-unikey noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd"
MEDIA_GAME="gamescope imv mangohud mpv obs-studio steam firefox"

# Merge all into one master list
ALL_PKGS="$SYS_HW $CLI_UTIL $ARCHIVES $DEV_CORE $XORG_WM $INPUT_FONT $MEDIA_GAME"

# Pre-Checks
if ! command -v paru >/dev/null 2>&1; then
    echo "[ERROR] paru is not installed. Exiting." | tee -a "$LOG_FILE"
    exit 1
fi

# Execution & Logging
echo "[INFO] Starting installation at $(date)" >> "$LOG_FILE"

if paru -S --needed $ALL_PKGS 2>> "$LOG_FILE"; then
    echo "[SUCCESS] All packages checked/installed successfully." | tee -a "$LOG_FILE"
else
    echo "[ERROR] Paru encountered an error. Check $LOG_FILE for details." >&2
    exit 1
fi
