#!/bin/bash

HELIX_SOURCE=~/dotfiles/helix
HELIX=~/.config/helix

ALACRITTY_SOURCE=~/dotfiles/alacritty
ALACRITTY=~/.config/alacritty

ZELLIJ_SOURCE=~/dotfiles/zellij
ZELLIJ=~/.config/zellij

FISH_SOURCE=~/dotfiles/fish
FISH=~/.config/fish

OMF_SOURCE=~/dotfiles/omf
OMF=~/.config/omf

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
create_symlink "$OMF_SOURCE" "$OMF"
create_symlink "$EFM_SOURCE" "$EFM"
create_symlink "$CONKY_SOURCE" "$CONKY"
create_symlink "$PHPACTOR_SOURCE" "$PHPACTOR"

echo "Updating the system"
sudo dnf update -y

echo "Ensure the ~/.config directory exists"
mkdir -p ~/.config

echo "Install dependencies"
sudo dnf install -y cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++ perl-core openssl-devel

echo "Install utilities"
sudo dnf install -y keepassxc syncthing golang fish npm util-linux-user helix python3 python3-pip snapd

create_symlink "$SNAP_SOURCE" "$SNAP"

echo "Install python development tools"
python3 --version
sudo dnf install -y python3-devel zlib-devel bzip2-devel sqlite-devel libffi-devel

echo "Upgrade python3 pip"
pip3 install --upgrade pip

echo "Install python language server pylsp"
pip install -U 'python-lsp-server[all]'

echo "Install rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup update

echo "Install alacritty"
cargo install alacritty
echo "Install zellij"
cargo install --locked zellij

rustup update

echo "Install rust analyzer"
rustup component add rust-analyzer

echo "Install Node version manager (nvm)"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

echo "Loading Node version manager (nvm)"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Install Node.js and npm using nvm"
nvm install node

echo "Install bash language server, vscode language server, typescript and typescript language server"
npm install -g bash-language-server vscode-langservers-extracted typescript typescript-language-server

echo "Install Oh My Fish (omf)"
curl -L https://get.oh-my.fish | fish

echo "Set fish as the default shell"
chsh -s /usr/bin/fish

echo "Install nvm from omf"
omf install nvm

echo "Start Syncthing service"
systemctl --user start syncthing

echo "Enable Syncthing to start on Boot"
systemctl --user enable syncthing

echo "Install efm-langserver"
go install github.com/mattn/efm-langserver@latest
efm-langserver -v

echo "Install phpactor"
cd ~/Downloads
curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
chmod a+x phpactor.phar
mv phpactor.phar ~/.local/bin/phpactor
phpactor status

echo "Install intelephense"
nvm use --lts
npm install -g intelephense

echo "Install deno"
curl -fsSL https://deno.land/install.sh | sh

echo "Install docker language server"
npm install -g dockerfile-language-server-nodejs

echo "Install docker compose language server"
npm install -g @microsoft/compose-language-service

echo "Install Ansible and YAML language server"
npm i -g @ansible/ansible-language-server 
npm i -g yaml-language-server@next

echo "Install sevelte language server and typescript svelte plugin"
npm i -g svelte-language-server
npm i -g typescript-svelte-plugin

echo "Install SQL language server"
npm i -g sql-language-server

echo "Install TailwindCSS language server"
npm i -g @tailwindcss/language-server

echo "Install TOML language server"
cargo install taplo-cli --locked --features lsp

# echo "Install markdown language servers"
# sudo snap install marksman

# echo "Install ltex language server for spellcheck"
# pip install ltex-ls

echo "Installation complete. Please restart your terminal."

