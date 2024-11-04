#!/bin/bash

# Function to detect the distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "Could not detect distribution."
        exit 1
    fi
}

# Function to install packages based on distribution
install_packages() {
    case "$DISTRO" in
        ubuntu|debian)
            echo "Detected Debian-based system. Installing packages..."
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y apache bind9 build-essential curl dnsutils fail2ban git htop lsof \
                                ncdu net-tools neovim nginx nmap rsync shellcheck sysstat tmux tree unzip
            ;;
        arch)
            echo "Detected Arch Linux system. Installing packages..."
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm apache base-devel bind curl fail2ban git htop inetutils lsof \
                                       ncdu neovim nginx nmap rsync sysstat tmux tree unzip
            ;;
        fedora)
            echo "Detected Fedora-based system. Installing packages..."
            sudo dnf update -y
            sudo dnf install -y apache bind bind-utils curl fail2ban firewalld git htop lsof ncdu \
                               net-tools neovim nginx nmap rsync shellcheck sysstat tmux tree unzip
            ;;
        *)
            echo "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

# Function to install Starship
install_starship() {
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
}

# Function to configure Starship
configure_starship() {
    echo "Configuring Starship..."
    mkdir -p ~/.config
    curl -o ~/.config/starship.toml https://starship.rs/presets/toml/no-nerd-font.toml

    # Add Starship initialization to shell profile
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
}

# Function to configure Tmux
configure_tmux() {
    echo "Configuring Tmux..."
    cat << 'EOF' > ~/.tmux.conf
# Enable mouse mode
set -g mouse on

# Set prefix to Ctrl-a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Split panes using | and -
bind | split-window -h
bind - split-window -v

# Set default terminal mode to 256color
set -g default-terminal "screen-256color"

# Set the status bar to use Starship
set-option -g status off
EOF
}

# Function to configure Neovim
configure_neovim() {
    echo "Configuring Neovim..."
    mkdir -p ~/.config/nvim
    cat << 'EOF' > ~/.config/nvim/init.vim
" Basic Neovim settings

" Set line numbers
set number

" Enable syntax highlighting
syntax on

" Set tab and indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Enable mouse support
set mouse=a

" Configure clipboard to use system clipboard
set clipboard=unnamedplus

" Set color scheme
colorscheme desert
EOF
}

# Main installation and configuration flow
detect_distro
install_packages
install_starship
configure_starship
configure_tmux
configure_neovim

# Final message
echo "Installation and configuration complete!"
echo "Restart your terminal or source your shell profile to start using Starship."
