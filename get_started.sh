#!/bin/bash

# File: get_started.sh
# Brief: This script is used to install the basic packages for the system
# Author: Pedro De Santi
# Date: 06/2023

# How to run this script?
# chmod +x get_started.sh
# ./get_started.sh

###############################
# Update the list of packages #
###############################

echo -e "Updating the list of packages...\n"
sudo apt update -y
sudo apt upgrade -y

##############################
# Install the basic packages #
##############################

echo ""
read -p "Do you want to install the basic packages? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing the basic packages...\n"

    sudo apt install build-essential -y
    sudo apt install cmake -y
    sudo apt install python3 -y
    sudo apt install python3-pip -y
    sudo apt install git -y
    sudo apt install uncrustify -y
    sudo apt install curl -y
    sudo apt install libusb-1.0-0-dev -y
    sudo apt install xclip -y
    sudo apt install neofetch -y
    sudo apt install cmatrix -y
    sudo apt install snapd -y

    echo -e "Basic packages installed successfully!\n"
fi

#################
# Configure git #
#################

echo ""
read -p "Do you want to configure git? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Enter the git username: "
    read git_username

    echo -e "Enter the git email: "
    read git_email

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    echo -e "Git configured successfully!\n"

    echo ""
    read -p "Do you want to configure the SSH? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then
        ssh-keygen -t ed25519 -C "$git_email"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        xclip -sel clip < ~/.ssh/id_ed25519.pub
        echo -e "SSH configured successfully! The SSH public key was copied to the clipboard!\n"
    fi
fi

##################
# Install VsCode #
##################

echo ""
read -p "Do you want to install VsCode? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing VsCode...\n"

    sudo apt-get install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y

    echo -e "VsCode installed successfully!\n"

    curl -o vscode.deb -fLO "https://go.microsoft.com/fwlink/?LinkID=760868"
    sudo apt install ./vscode.deb -y
    rm -f vscode.deb
fi

#Q? What does wget -qO- do?
#A. It downloads the file and prints it to stdout. The -q option makes it quiet, and the -O- option makes it print to stdout.

##########################
# Install gnome packages #
##########################

echo ""
read -p "Do you want to install gnome packages? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    sudo apt install gnome-tweaks -y
    sudo apt install gnome-shell-extensions -y
    sudo apt install chrome-gnome-shell -y
    sudo apt install dconf-editor -y
    sudo apt install dconf-cli -y
    echo -e "Gnome packages installed successfully!"
fi

################
# Install Fish #
################

echo ""
read -p "Do you want to install fish? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing fish...\n"
    sudo apt-add-repository ppa:fish-shell/release-3 -y
    sudo apt update -y
    sudo apt install fish -y
    sudo echo -e $(which fish) | sudo tee -a /etc/shells
    sudo chsh -s $(which fish)

    echo -e "Installing Starship..."
    curl -fsSL https://starship.rs/install.sh | sh
    echo -e "starship init fish | source" >> ~/.config/fish/config.fish

    echo -e "Fish installed successfully!\n"
fi

#####################
# Install Nerdfonts #
#####################

echo ""
read -p "Do you want to install Nerdfonts? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing Nerdfonts...\n"
    
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFontMono-Bold.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Light/FiraCodeNerdFontMono-Light.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFontMono-Medium.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Retina/FiraCodeNerdFontMono-Retina.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFontMono-SemiBold.ttf
    
    echo -e "Nerdfonts installed successfully!\n"
fi

################
# Install Tmux #
################

echo ""
read -p "Do you want to install Tmux? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing Tmux...\n"
    sudo apt install tmux -y
    echo -e "Tmux installed successfully!\n"
fi

##########################
# Install STM32 Software #
##########################

echo -e "\nFor installing the STM32 Software, follow the instructions in the link below:\n"
echo -e "\tSTM32CubeProgrammer: https://www.st.com/en/development-tools/stm32cubeprog.html"
echo -e "\tSTM32CubeMX: https://www.st.com/en/development-tools/stm32cubemx.html"
echo -e "\tSTM32CubeMonitor: https://www.st.com/en/development-tools/stm32cubemonitor.html"

###################
# Install ARM GCC #
###################

echo -e "\nFor installing the ARM GCC, follow the instructions in the link below:\n"
echo -e "\tARM GCC: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads"


echo ""
read -p "Do you want to install ARM GCC? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing ARM GCC...\n"

    curl -fLO "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2"
    tar -xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
    sudo mkdir /opt/arm-none-eabi
    sudo mv gcc-arm-none-eabi-10.3-2021.10 /opt/arm-none-eabi
    rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

    echo -e "ARM GCC installed successfully!\n"
fi

#Q? What does tar -xvf do?
#A. tar -xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
#   x: This tells tar to extract the files.
#   v: This option will print the name of each file as it’s extracted.
#   f: This tells tar that you are going to give it a file name to work with.



# # Install the oh-my-fish
# curl -L https://get.oh-my.fish | fish # Install the oh-my-fish

# # Install the bobthefish theme
# omf install bobthefish # Install the bobthefish theme

# # Install the powerline fonts
# sudo apt install fonts-powerline -y # Install the powerline fonts

# # Install the powerline-shell
# pip3 install powerline-shell # Install the powerline-shell

# # Install the powerline-shell theme
# echo -e "function fish_prompt
#     powerline-shell --shell bare $status
# end" >> ~/.config/fish/config.fish # Install the powerline-shell theme

# # Install the powerline-shell theme
# echo -e "powerline-shell --shell bare $status" >> ~/.config/fish/config.fish # Install the powerline-shell theme



