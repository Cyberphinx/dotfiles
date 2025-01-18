#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

HELIX_SOURCE=~/dotfiles/helix
HELIX=~/.config/helix

ALACRITTY_SOURCE=~/dotfiles/alacritty
ALACRITTY=~/.config/alacritty

ZELLIJ_SOURCE=~/dotfiles/zellij
ZELLIJ=~/.config/zellij

FISH_SOURCE=~/dotfiles/fish
FISH=~/.config/fish

EFM_SOURCE=~/dotfiles/efm-langserver
EFM=~/.config/efm-langserver

CONKY_SOURCE=~/dotfiles/conky
CONKY=~/.config/conky

PHPACTOR_SOURCE=~/dotfiles/phpactor
PHPACTOR=~/.config/phpactor

SNAP_SOURCE=/var/lib/snapd/snap
SNAP=/snap

# Function to create symlink if it doesn't exist
create_symlink() {
    local source=$1
    local target=$2

    if [ -e "$target" ]; then
        echo "Symlink $target already exists"
    else
        ln -s "$source" "$target"
        echo "Created symlink from $source to $target"
    fi
}

echo "Creating symlinks to dotfiles if they don't exist already"
create_symlink "$HELIX_SOURCE" "$HELIX"
create_symlink "$ALACRITTY_SOURCE" "$ALACRITTY"
create_symlink "$ZELLIJ_SOURCE" "$ZELLIJ"
create_symlink "$FISH_SOURCE" "$FISH"
create_symlink "$EFM_SOURCE" "$EFM"
create_symlink "$CONKY_SOURCE" "$CONKY"
create_symlink "$PHPACTOR_SOURCE" "$PHPACTOR"
