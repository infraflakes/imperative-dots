#!/usr/bin/env sh

# Exit on unset variables
set -u

LOG_FILE="$HOME/pkg_install.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Package Categorization
sudo dnf copr enable atim/bottom -y
sudo dnf copr enable lihaohong/yazi -y
sudo dnf copr enable lukenukem/asus-linux -y
sudo dnf copr enable @xlibre/xlibre-xserver -y
sudo dnf copr enable lxdes/bluetuith -y
DEV_CORE="neovim"
SYS_HW="lm_sensors tailscale supergfxctl NetworkManager-tui bluetuith tuned"
WM="xlibre-xserver xlibre-xf86-input-libinput xdg-desktop-portal xdg-desktop-portal-gtk slock arandr xset xsetroot maim xclip feh brightnessctl"
CLI_UTIL="bat bottom fastfetch fd fzf ncdu ripgrep stow tmux yazi"
ARCHIVES="p7zip unrar"
INPUT_FONT="fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-unikey google-noto-fonts-all"
MEDIA_GAME="gamescope mangohud steam lutris imv mpv obs-studio firefox" # launch games with `gamescope --mangoapp -W 1920 -H 1080 -r 144 -f -- %command%`

# Merge all into one master list
ALL_PKGS="$SYS_HW $CLI_UTIL $ARCHIVES $DEV_CORE $INPUT_FONT $MEDIA_GAME $WM"

# Execution & Logging
echo "[INFO] Starting installation at $(date)" >> "$LOG_FILE"

if sudo dnf install -y $ALL_PKGS 2>> "$LOG_FILE"; then
    echo "[SUCCESS] All packages checked/installed successfully." | tee -a "$LOG_FILE"
    sudo systemctl enable tailscaled tuned
else
    echo "[ERROR] DNF encountered an error. Check $LOG_FILE for details." >&2
    exit 1
fi
