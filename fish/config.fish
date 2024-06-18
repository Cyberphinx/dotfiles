if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx EDITOR hx

    # Configure auto-attach/exit to your likings (default is off).
    # set ZELLIJ_AUTO_ATTACH true
    # set ZELLIJ_AUTO_EXIT true
    # eval (zellij setup --generate-auto-start fish | string collect)
    # Add ~/.cargo/bin to PATH only for interactive sessions
    # set -gx PATH $PATH ~/.cargo/bin

    fish_add_path /usr/local/bin
    fish_add_path /opt/godot/
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.fly/bin
    fish_add_path ~/.bun/bin
    fish_add_path /home/vampire/.nvm/versions/node/v21.4.0/bin
    fish_add_path /home/vampire/.config/composer/vendor/bin

    set -x DPRINT_INSTALL "/home/vampire/.dprint"
    set -x PATH "$DPRINT_INSTALL/bin" $PATH
    set -gx PATH $PATH /usr/bin/node
    set -x PATH $PATH $HOME/go/bin
    set -gx PATH $HOME/.local/share/lua-language-server/bin $PATH
    set -gx PATH $PATH /home/vampire/.local/share/bob/nvim-bin
    # set -gx PATH $PATH /home/vampire/.nvm/versions/node/v21.4.0/bin
    set -x DENO_INSTALL /home/vampire/.deno
    set -x PATH $DENO_INSTALL/bin $PATH

    alias p="pass show ldapass | wl-copy"
end
