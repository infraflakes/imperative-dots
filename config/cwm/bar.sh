#!/usr/bin/env sh

# ─────────── Tokyonight Palette ───────────
BG="#1a1b26"         # Clean dark background
FG="#c0caf5"         # Main text
BLACK="#414868"      # Divider line gray
YELLOW="#e0af68"     # Battery Yellow
CYAN="#7dcfff"       # Time Cyan
BLUE="#86AFEF"       # Time Cyan
MAGENTA="#bb9af7"    # Date Magenta
GREEN="#9ece6a"      # Playing Status Accent
RED="#f7768e"
COMMENT="#565f89"    # Muted Gray Accent

LAST_OUTPUT=""

while true; do
    # 1. Left Block - Clickable Playerctl Engine (Controls anything!)
    if command -v playerctl >/dev/null 2>&1; then
        # Check if any active player is detected on the D-Bus
        PLAYER_STATUS=$(playerctl status 2>/dev/null)

        if [ -n "$PLAYER_STATUS" ]; then
            TRACK_INFO=$(playerctl metadata --format "{{ title }} - {{ artist }}" 2>/dev/null | cut -c1-70)

            if [ "$PLAYER_STATUS" = "Playing" ]; then
                TOGGLE_BTN="%{F${GREEN}}[PAUSE]%{F${FG}}"
            else
                TOGGLE_BTN="%{F${COMMENT}}[PLAY]%{F${FG}}"
            fi

            # Formulate our clickable action tag macros using playerctl primitives
            PREV_ACTION="%{A:playerctl previous:}%{F${BLUE}}[<<]%{F${FG}}%{A}"
            TOGL_ACTION="%{A:playerctl play-pause:}${TOGGLE_BTN}%{A}"
            NEXT_ACTION="%{A:playerctl next:}%{F${MAGENTA}}[>>]%{F${FG}}%{A}"

            LEFT_STR="  ${PREV_ACTION}  ${TOGL_ACTION}  ${NEXT_ACTION}  %{F${RED}}${TRACK_INFO}%{F${FG}}"
        else
            LEFT_STR="  [no media]"
        fi
    else
        LEFT_STR="  [no playerctl]"
    fi

    # 2. Center Block - Time and Date
    # 2. Status Data Block Generation
    DATE_STR=$(date "+%Y-%m-%d")
    TIME_STR=$(date "+%H:%M:%S")

    # Keeping them unified using CYAN for that crisp, clean look!
    DATETIME_STR="%{F${CYAN}}${TIME_STR}%{F${BLACK}} | %{F${GREEN}}${DATE_STR}"

    # 3. Right Block - Permanent Yellow Battery Metric
    if [ -d /sys/class/power_supply/BAT0 ]; then
        BAT=$(cat /sys/class/power_supply/BAT0/capacity)
        BAT_STR="%{F${YELLOW}}BAT: ${BAT}%"
    else
        BAT_STR="%{F${YELLOW}}AC"
    fi

    # 4. Triple Axis Layout Serialization (Time and Date pushed to the right!)
    # We sequence them right after %{r} with a clean divider block before the battery.
    CURRENT_OUTPUT="%{B${BG}}%{l}${LEFT_STR}%{r}${DATETIME_STR}%{F${BLACK}} | ${BAT_STR}  "

    if [ "$CURRENT_OUTPUT" != "$LAST_OUTPUT" ]; then
        echo "$CURRENT_OUTPUT"
        LAST_OUTPUT="$CURRENT_OUTPUT"
    fi

    sleep 1
done | lemonbar -p -d -n lemonbar -g "x28" -f "monospace:weight=bold:size=10" -B "$BG" -F "$FG" -a 20 | sh
