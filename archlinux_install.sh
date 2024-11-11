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

# SNAP_SOURCE=/var/lib/snapd/snap
# SNAP=/snap

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

# Ensure yay is installed
if ! command_exists yay; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

echo "Updating the system"
sudo pacman -Syu --noconfirm

echo "Ensure the ~/.config directory exists"
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi

echo "Install dependencies"
dependencies=(cmake freetype2 fontconfig libxcb libxkbcommon gcc perl openssl jdk11-openjdk lua jq curl unzip rustup networkmanager-openvpn starship)
for package in "${dependencies[@]}"; do
    if ! pacman -Qi $package &>/dev/null; then
        sudo pacman -S --noconfirm $package
    else
        echo "$package is already installed"
    fi
done

echo "Initialize rustup"
if command -v rustup &>/dev/null; then
    rustup default stable
    rustup --version
    rustc --version
else
    echo "rustup is not installed"
fi

echo "Install utilities"
utilities=(keepassxc syncthing go fish npm util-linux helix python python-pip conky)
for utility in "${utilities[@]}"; do
    if ! pacman -Qi $utility &>/dev/null; then
        sudo pacman -S --noconfirm $utility
    else
        echo "$utility is already installed"
    fi
done

echo "Install PHP and some common extensions"
php_packages=(php php-gd php-intl)
for php_package in "${php_packages[@]}"; do
    if ! pacman -Qi $php_package &>/dev/null; then
        sudo pacman -S --noconfirm $php_package
    else
        echo "$php_package is already installed"
    fi
done

echo "Install python development tools"
python_tools=(python python-pip python-virtualenv)
for tool in "${python_tools[@]}"; do
    if ! pacman -Qi $tool &>/dev/null; then
        sudo pacman -S --noconfirm $tool
    else
        echo "$tool is already installed"
    fi
done

echo "Reinstall the libraries to ensure they are up to date with python"
libraries=(zlib bzip2 sqlite libffi)
for library in "${libraries[@]}"; do
    if ! pacman -Qi $library &>/dev/null; then
        sudo pacman -S --noconfirm $library
    else
        echo "$library is already installed"
    fi
done

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Array of commands and their installation commands
declare -A commands
commands=(
    ["efm-langserver"]="go install github.com/mattn/efm-langserver@latest"
    ["deno"]="curl -fsSL https://deno.land/install.sh | sh"
    ["taplo"]="cargo install taplo-cli --locked --features lsp"
    ["sqlx"]="cargo install sqlx-cli"
    ["rustc"]="curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh && source \$HOME/.cargo/env"
    ["rust-analyzer"]="rustup component add rust-analyzer"
    ["nvm"]="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\""
    ["node"]="nvm install node"
    ["composer"]="php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && php -r \"if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\" && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer && php -r \"unlink('composer-setup.php');\""
    ["phpcs"]="composer global require \"squizlabs/php_codesniffer=*\""
    ["marksman"]="yay -S marksman-bin"
    ["fisher"]="curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
)

# Log file for errors
LOG_FILE="install_errors.log"

# Loop through the array and install each command if not already installed
for cmd in "${!commands[@]}"; do
    if command_exists "$cmd"; then
        echo "$cmd is already installed. Skipping installation."
    else
        echo "Installing $cmd..."
        eval "${commands[$cmd]}" || {
            echo "Failed to install $cmd. Check $LOG_FILE for details."
            echo "[$(date)] Failed to install $cmd" >> "$LOG_FILE"
        }
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
nvm install --lts
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

# Set fish as the default shell
if [ "$SHELL" = "/usr/bin/fish" ]; then
    echo "Fish is already the default shell. Skipping setting default shell."
else
    echo "Setting fish as the default shell..."
    chsh -s /usr/bin/fish
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

# Check if phpactor is installed
if command_exists phpactor; then
    echo "phpactor is already installed. Skipping installation."
else
    echo "Installing phpactor..."
    cd ~/Downloads
    curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
    chmod a+x phpactor.phar

    # Ensure the target directory exists
    if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin"
    fi
    mv phpactor.phar ~/.local/bin/phpactor
fi

echo "Installation complete. Please restart your terminal. Don't forget to run `fisher install jorgebucaran/nvm.fish` to install nvm for fish shell."