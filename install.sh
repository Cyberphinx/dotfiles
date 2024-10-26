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

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Updating the system"
sudo dnf update -y

echo "Ensure the ~/.config directory exists"
mkdir -p ~/.config

echo "Install dependencies"
sudo dnf install -y cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++ perl-core openssl-devel java-11-openjdk lua jq curl

echo "Install utilities"
sudo dnf install -y keepassxc syncthing golang fish npm util-linux-user helix python3 python3-pip snapd conky

echo "Install php utilities"
sudo dnf install php php-cli php-mbstring php-xml php-json php-curl php-zip

# create_symlink "$SNAP_SOURCE" "$SNAP"

echo "Install python development tools"
python3 --version
sudo dnf install -y python3-devel zlib-devel bzip2-devel sqlite-devel libffi-devel

# Array of commands and their installation commands
declare -A commands
commands=(
    ["efm-langserver"]="go install github.com/mattn/efm-langserver@latest"
    ["deno"]="curl -fsSL https://deno.land/install.sh | sh"
    ["taplo"]="cargo install taplo-cli --locked --features lsp"
    ["sqlx"]="cargo install sqlx-cli"
    ["rustc"]="curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source \$HOME/.cargo/env"
    ["alacritty"]="cargo install alacritty"
    ["zellij"]="cargo install --locked zellij"
    ["rust-analyzer"]="rustup component add rust-analyzer"
    ["nvm"]="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\""
    ["node"]="nvm install node"
    ["omf"]="curl -L https://get.oh-my.fish | fish"
    ["efm-langserver"]="go install github.com/mattn/efm-langserver@latest"
    ["deno"]="curl -fsSL https://deno.land/install.sh | sh"
    ["taplo"]="cargo install taplo-cli --locked --features lsp"
    ["composer"]="php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && php -r \"if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\" && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer && php -r \"unlink('composer-setup.php');\""
    ["phpcs"]="composer global require \"squizlabs/php_codesniffer=*\""
    ["fisher"]="curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
)

# Loop through the array and install each command if not already installed
for cmd in "${!commands[@]}"; do
    if command_exists "$cmd"; then
        echo "$cmd is already installed. Skipping installation."
    else
        echo "Installing $cmd..."
        eval "${commands[$cmd]}"
    fi
done

# Update Rust
echo "Updating Rust..."
rustup update

# Function to check if a npm package is globally installed
npm_package_exists() {
    npm list -g --depth=0 | grep -q "$1"
}

echo "Nvm use lts version of node..."
nvm use --lts

# Array of npm packages to install
packages=(
    "bash-language-server"
    "vscode-langservers-extracted"
    "typescript"
    "typescript-language-server"
    "dockerfile-language-server-nodejs"
    "@microsoft/compose-language-service"
    "@ansible/ansible-language-server"
    "yaml-language-server@next"
    "svelte-language-server"
    "typescript-svelte-plugin"
    "sql-language-server"
    "@tailwindcss/language-server"
    "intelephense"
    "bun"
)

# Loop through the array and install each package if not already installed
for package in "${packages[@]}"; do
    if npm_package_exists "$package"; then
        echo "$package is already installed. Skipping installation."
    else
        echo "Installing $package..."
        npm install -g "$package"
    fi
done

echo "Upgrade python3 pip"
pip3 install --upgrade pip

echo "Install python language server pylsp"
pip install -U 'python-lsp-server[all]'

# Set fish as the default shell
if [ "$SHELL" = "/usr/bin/fish" ]; then
    echo "Fish is already the default shell. Skipping setting default shell."
else
    echo "Setting fish as the default shell..."
    chsh -s /usr/bin/fish
fi

# Install nvm from omf
if omf list | grep -q nvm; then
    echo "nvm is already installed in omf. Skipping omf nvm installation."
else
    echo "Installing nvm from omf..."
    omf install nvm
fi

# Start Syncthing service
if systemctl --user is-active --quiet syncthing; then
    echo "Syncthing service is already running. Skipping start."
else
    echo "Starting Syncthing service..."
    systemctl --user start syncthing
fi

# Enable Syncthing to start on Boot
if systemctl --user is-enabled --quiet syncthing; then
    echo "Syncthing is already enabled to start on boot. Skipping enable."
else
    echo "Enabling Syncthing to start on Boot..."
    systemctl --user enable syncthing
fi

# Install markdown language servers
if snap list | grep -q marksman; then
    echo "marksman is already installed. Skipping marksman installation."
else
    echo "Installing markdown language servers..."
    sudo snap install marksman
fi

echo "Install ltex language server for spellcheck"
if [ ! -d "/opt/ltex-ls" ]; then
    cd ~/Downloads
    wget https://github.com/valentjn/ltex-ls/releases/download/16.0.0/ltex-ls-16.0.0-linux-x64.tar.gz
    sudo mkdir -p /opt/ltex-ls
    sudo tar -xzf ltex-ls-16.0.0-linux-x64.tar.gz -C /opt
    echo "ltex-ls installation completed."
else
    echo "/opt/ltex-ls already exists. Skipping installation."
fi

echo "Checking if Docker Engine is already installed..."
if ! command -v docker &> /dev/null; then
    echo "Docker Engine not found. Proceeding with installation..."

    echo "Uninstall old versions of Docker Engine"
    sudo dnf remove -y docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-selinux \
                      docker-engine-selinux \
                      docker-engine

    echo "Install Docker Engine"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Start Docker Engine"
    sudo systemctl start docker

    echo "Enable Docker to start on boot"
    sudo systemctl enable docker

    echo "Run hello-world image from Docker Engine"
    sudo docker run hello-world

    echo "Docker Engine installation and test completed."
else
    echo "Docker Engine is already installed. Skipping installation."
fi

# Check if phpactor is installed
if command_exists phpactor; then
    echo "phpactor is already installed. Skipping installation."
else
    echo "Installing phpactor..."
    cd ~/Downloads
    curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
    chmod a+x phpactor.phar
    mv phpactor.phar ~/.local/bin/phpactor
    phpactor status
fi

echo "Installation complete. Please restart your terminal."

