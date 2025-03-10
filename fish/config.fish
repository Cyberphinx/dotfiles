if status is-interactive
    # Commands to run in interactive sessions can go here

    function fish_user_env
        set -gx TERM xterm-256color
    end

    # Set default editor to helix, eg. crontab -e
    set -gx EDITOR vim
    # Do not alias hx to helix except archlinux
    # alias hx='helix'

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

    # Start starship shell prompt
    starship init fish | source

end
