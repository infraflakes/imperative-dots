# Generate key: ssh-keygen -t ed25519 -C "infraflakes@proton.me"
# ssh-add ~/.ssh/id_ed25519
# `cat ~/.ssh/id_ed25519.pub` then copy and make new ssh key on github

function ssh_agent --on-event fish_interactive
    set -gx SSH_AUTH_SOCK "/run/user/1000/ssh-agent"

    if not test -S $SSH_AUTH_SOCK
        ssh-agent -a $SSH_AUTH_SOCK > /dev/null
    end
end
