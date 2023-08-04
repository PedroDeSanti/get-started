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
    sudo apt install zip unzip -y
    sudo apt install gdb-multiarch -y
    sudo apt install vim -y
    sudo apt install openocd -y
    sudo apt install stlink-tools -y

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
fi

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


#########################
# Install Dracula Theme #
#########################

echo ""
read -p "Do you want to install Dracula Theme? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing Dracula Theme...\n"

    echo ""
    read -p "Do you want to install GTK Theme? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then

        echo -e "Installing GTK Dracula Theme...\n"

        curl -o Dracula.zip -fLO https://github.com/dracula/gtk/archive/master.zip
        unzip Dracula.zip
        mkdir -p ~/.themes/Dracula
        cp -r gtk-master/* ~/.themes/Dracula
        rm -rf gtk-master
        rm -f Dracula.zip

        gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
        gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

        echo -e "Installing GTK Dracula Theme installed!\n"

    fi

    echo ""
    read -p "Do you want to install Icon Theme? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then

        echo -e "Installing Icon Dracula Theme...\n"

        curl -fLO https://github.com/dracula/gtk/files/5214870/Dracula.zip
        unzip Dracula.zip
        mkdir -p ~/.icons/Dracula
        cp -r Dracula/* ~/.icons/Dracula
        rm -rf Dracula
        rm -f Dracula.zip

        gsettings set org.gnome.desktop.interface icon-theme "Dracula"

        echo -e "Installing Icon Dracula Theme installed!\n"

    fi

    echo ""
    read -p "Do you want to install Gnome Terminal Theme? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then

        echo -e "Installing Gnome Terminal Dracula Theme...\n"

        git clone https://github.com/dracula/gnome-terminal
        cd gnome-terminal
        ./install.sh
        cd ..
        rm -rf gnome-terminal

        echo -e "Installing Gnome Terminal Dracula Theme installed!\n"

    fi

    echo ""
    read -p "Do you want to install Gedit Theme? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then

        echo -e "Installing Gedit Dracula Theme...\n"

        wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
        mkdir -p $HOME/.local/share/gedit/styles/
        mv dracula.xml $HOME/.local/share/gedit/styles/

        echo -e "Installing Gedit Dracula Theme installed! Activate in Gedit's preferences dialog.\n"

    fi

    echo ""
    read -p "Do you want to install Tela Circle Icons Theme? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then

        echo -e "Installing Tela Circle Icons Theme...\n"

        git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
        cd Tela-circle-icon-theme
        ./install.sh
        cd ..
        rm -rf Tela-circle-icon-theme

        echo -e "Installing Tela Circle Icons Theme installed!\n"

    fi
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
    chsh -s $(which fish)

    echo -e "Installing Starship..."
    curl -fsSL https://starship.rs/install.sh | sh
    mkdir -p ~/.config/fish/
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

    cd
    curl -fLO "https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2"
    tar -xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
    sudo mkdir /opt/arm-none-eabi
    sudo mv gcc-arm-none-eabi-10.3-2021.10 /opt/arm-none-eabi
    rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

    echo -e "ARM GCC installed successfully!\n"
fi

##################
# Install J-Link #
##################

echo -e "\nFor installing the J-Link, follow the instructions in the link below:\n"
echo -e "\tJ-Link: https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb"

###################
# Install Flutter #
###################

echo ""
read -p "Do you want to install Flutter? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing Flutter...\n"
    
    cd 

    sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 -y
    sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
    sudo apt install default-jdk -y

    sudo snap install flutter --classic
    flutter sdk-path

    curl -fLO "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.20/android-studio-2022.2.1.20-linux.tar.gz"
    tar -xvf android-studio-2022.2.1.20-linux.tar.gz
    sudo mv android-studio /opt/
    rm android-studio-2022.2.1.20-linux.tar.gz

    cd /opt/android-studio/bin
    ./studio.sh

    #or

    #sudo add-apt-repository ppa:maarten-fonville/android-studio
    #sudo apt update
    #sudo apt install android-studio -y

    flutter config --android-studio-dir=/opt/android-studio
    flutter doctor --android-licenses
    flutter doctor

    echo -e "Flutter installed successfully!\n"
    echo -e "Remember to install cmd line tools in Android Studio!\n"
fi

###################
# Install Spotify #
###################

echo ""
read -p "Do you want to install Spotify? (y/n) " answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo -e "Installing Spotify...\n"
    
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update -y && sudo apt-get install spotify-client -y

    echo -e "Spotify installed successfully!\n"
fi




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


