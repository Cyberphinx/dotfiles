# Unset the default fish greeting text which messes up Zellij
set fish_greeting

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

    # Language input settings
    set -x GTK_IM_MODULE fcitx5
    set -x QT_IM_MODULE fcitx5
    set -x XMODIFIERS "@im=fcitx5"

    # Language Server for coding
    set -gx PATH $PATH /usr/bin/node
    set -x PATH $PATH $HOME/go/bin
    set -gx PATH $HOME/.local/share/lua-language-server/bin $PATH
    set -gx PATH $PATH $HOME/.local/share/bob/nvim-bin
    set -x DENO_INSTALL $HOME/.deno
    set -x PATH $DENO_INSTALL/bin $PATH

    # set the XDG environment variables in fish
    set -Ux XDG_CONFIG_HOME $HOME/.config
    set -Ux XDG_DATA_HOME $HOME/.local/share
    set -Ux XDG_CACHE_HOME $HOME/.cache
end
