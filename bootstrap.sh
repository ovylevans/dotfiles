#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function install_pacman_packages
{
    sudo pacman -S --noconfirm - < ${SCRIPT_DIR}/pacman_package_list.txt
}

# Link kitty config
function link_kitty_config
{
    rm -rf ~/.config/kitty &> /dev/null
    
    ln -sf ${SCRIPT_DIR}/.config/kitty ~/.config/kitty
}

# Link bash aliases
function link_bash_aliases
{
    rm -rf ~/.bash_aliases
    ln -sf ${SCRIPT_DIR}/.bash_aliases ~/.bash_aliases
}

function install_nvim
{
    rm -rf /tmp/nvim
    git clone https://github.com/neovim/neovim.git /tmp/nvim
    cd /tmp/nvim
    make -j$(nproc) CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
}

function install_starship
{
    curl -sS https://starship.rs/install.sh | sh
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
}

function link_sway_configs
{
    ln -sf ${SCRIPT_DIR}/.config/sway ~/.config/sway
    ln -sf ${SCRIPT_DIR}/.config/rofi ~/.config/rofi
    ln -sf ${SCRIPT_DIR}/.config/waybar ~/.config/waybar
    ln -sf ${SCRIPT_DIR}/.config/wofi ~/.config/wofi
}

install_pacman_packages
install_nvim
install_starship
link_sway_configs
link_kitty_config
link_bash_aliases
