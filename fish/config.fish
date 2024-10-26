if status is-interactive
    # Commands to run in interactive sessions can go here

    # Set default editor to helix, eg. crontab -e
    set -gx EDITOR vim
    alias hx='helix'

    fish_add_path /usr/local/bin
    fish_add_path /usr/local/go/bin
    fish_add_path /opt/godot/
    fish_add_path /opt/ltex-ls/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.fly/bin
    fish_add_path ~/.bun/bin
    fish_add_path $HOME/.nvm/versions/node/v21.4.0/bin
    fish_add_path $HOME/.nvm/versions/node/v22.5.0/bin
    fish_add_path $HOME/.config/composer/vendor/bin
    fish_add_path ~/.composer/vendor/bin

    set -x DPRINT_INSTALL "$HOME/.dprint"
    set -x PATH "$DPRINT_INSTALL/bin" $PATH
    set -gx PATH $PATH /usr/bin/node
    set -x PATH $PATH $HOME/go/bin
    set -gx PATH $HOME/.local/share/lua-language-server/bin $PATH
    set -gx PATH $PATH $HOME/.local/share/bob/nvim-bin
    set -x DENO_INSTALL $HOME/.deno
    set -x PATH $DENO_INSTALL/bin $PATH

    # Detect if running under Wayland or X11
    if test -n "$XDG_SESSION_TYPE"
        switch $XDG_SESSION_TYPE
            case wayland
                # Define alias for Wayland
                alias p="pass show ldapass | wl-copy"
                alias s="pass show sdxpass | wl-copy"
            case x11
                # Define alias for X11
                alias p="pass show ldapass | xclip -selection clipboard"
                alias s="pass show sdxpass | xclip -selection clipboard"
        end
    else
        echo "Could not determine display server."
    end

    # Check if ssh-agent is running 
    # if not pgrep -f ssh-agent >/dev/null
    #     # Start ssh-agent
    #     eval (ssh-agent -c)
    #     set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    #     set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    # end
    # Check if SSH_AGENT_PID is set
    if not set -q SSH_AGENT_PID
        # Start ssh-agent and set environment variables
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    # Add SSH key to the agent (let ssh-agent to cache the passphrase for git)
    ssh-add ~/.ssh/id_ed25519

end
