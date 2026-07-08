set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'

set -gx SDL_IM_MODULE 'fcitx'
set -gx XMODIFIERS '@im=fcitx'
set -gx GTK_IM_MODULE 'fcitx'
set -gx QT_IM_MODULE 'fcitx'

set -gx TMUX_TMPDIR '/tmp'

set -gx XDG_CACHE_HOME "$HOME"'/.cache'
set -gx XDG_CONFIG_HOME "$HOME"'/.config'
set -gx XDG_DATA_HOME "$HOME"'/.local/share'
set -gx XDG_DESKTOP_DIR "$HOME"'/Desktop'
set -gx XDG_DOCUMENTS_DIR "$HOME"'/Documents'
set -gx XDG_DOWNLOAD_DIR "$HOME"'/Downloads'
set -gx XDG_MUSIC_DIR "$HOME"'/Music'
set -gx XDG_PICTURES_DIR "$HOME"'/Pictures'
set -gx XDG_STATE_HOME "$HOME"'/.local/state'
set -gx XDG_VIDEOS_DIR "$HOME"'/Videos'

set -q PATH; or set -g PATH # Ensure it exists
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.config/swm/bin
fish_add_path $HOME/.opencode/bin

set UID (id -u)
set -g fish_color_command 8ab4f8 --bold
set -g fish_color_param ccd0d9 --bold
set -g fish_color_redirection 8ab4f8 --bold
set -g fish_color_error cf6679 --bold
set -g fish_color_autosuggestion 908caa --bold
set -g fish_color_selection --reverse --bold

status is-login; and begin

end

status is-interactive; and begin

    ssh_agent

    alias cat bat
    alias cd scd
    alias e nvim
    alias tm 'tmux new-session -A -s default'

    sn cd init fish | source
    # fastfetch
    # echo "				Welcome back, $USER!"

end
