function ssh_agent --description 'Auto-starts and manages the ssh-agent socket'
    # Define the static socket path
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # If the socket doesn't exist, spawn the real agent
    if not test -S $SSH_AUTH_SOCK
        # Use command to bypass this wrapper function and call the actual binary
        eval (command ssh-agent -c -a $SSH_AUTH_SOCK >/dev/null)
    end
end
