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

    touch ~/.bashrc

    cat ~/.bashrc | grep "source ~/.bash_aliases" &> /dev/null

    if [ $? != 0 ]; then
        echo "source ~/.bash_aliases" >> ~/.bashrc
    fi;
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

    touch ~/.bashrc

    cat ~/.bashrc | grep -w 'starship init bash' &> /dev/null
    if [ $? != 0 ]; then
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
    fi;
}

function link_sway_configs
{
    rm -rf ~/.config/sway ~/.config/waybar ~/.config/wofi ~/.config/swaync ~/.config/wlogout
    ln -sf ${SCRIPT_DIR}/.config/sway ~/.config/sway
    ln -sf ${SCRIPT_DIR}/.config/waybar ~/.config/waybar
    ln -sf ${SCRIPT_DIR}/.config/wofi ~/.config/wofi
    ln -sf ${SCRIPT_DIR}/.config/swaync ~/.config/swaync
    ln -sf ${SCRIPT_DIR}/.config/wlogout ~/.config/wlogout
}

function install_yay
{
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay
    makepkg -s -i --noconfirm 
    popd
}

function install_wlogout
{
    echo "1" | yay --noconfirm --useask wlogout
}

link_bash_aliases
install_pacman_packages
install_yay
install_wlogout
install_nvim
install_starship
link_sway_configs
link_kitty_config