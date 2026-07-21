set UID (id -u)

# set -gx NOUVEAU_USE_ZINK '1'
# set -gx DRI_PRIME '1'

set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'

set -gx SDL_IM_MODULE 'fcitx'
set -gx XMODIFIERS '@im=fcitx'
set -gx GTK_IM_MODULE 'fcitx'
set -gx QT_IM_MODULE 'fcitx'

set -gx TMUX_TMPDIR '/tmp'
set -gx GOPATH $HOME/.local/share/go

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
fish_add_path $GOPATH/bin

# Commands (Flexoki Black)
set -g fish_color_command 100f0f --bold
# Parameters (Base-600 / Dark Gray for contrast)
set -g fish_color_param 6f6e69 --bold
# Redirections (Flexoki Black)
set -g fish_color_redirection 100f0f --bold
# Errors (Flexoki Red)
set -g fish_color_error af3029 --bold
# Autosuggestions (Base-300 / Muted Gray)
set -g fish_color_autosuggestion b7b5ac --bold
# Selection (Reverse video)
set -g fish_color_selection --reverse --bold

status is-login; and begin

end

status is-interactive; and begin

    if type -q direnv
      direnv hook fish | source
    end
    if test -e ~/.nix-profile/etc/profile.d/nix.fish
        source ~/.nix-profile/etc/profile.d/nix.fish
    end


    alias cd scd
    alias e nvim
    alias ls 'command ls --color=never'
    alias tm 'tmux new-session -A -s default'

    sn cd init fish | source
    # fastfetch
    # echo "				Welcome back, $USER!"

end
