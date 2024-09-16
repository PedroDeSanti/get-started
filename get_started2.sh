#!/bin/bash

# File: get_started.sh
# Brief: This script is used to install the basic packages for the system
# Author: Pedro De Santi
# Date: 09/2024

ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
WARNING_COLOR='\033[0;33m'
NO_COLOR='\033[0m' # No Color

ERROR_COUNT=0

# Função para log normal (sem cor)
log() {
    echo -e "$1"
}

# Função para log de erro (vermelho)
log_error() {
    log "${ERROR_COLOR}$1${NO_COLOR}" >&2
}

# Função para log de sucesso (verde)
log_success() {
    log "${SUCCESS_COLOR}$1${NO_COLOR}"
}

# Função para log de aviso (amarelo)
log_warning() {
    log "${WARNING_COLOR}$1${NO_COLOR}"
}

apt_install() {
    local package_name=$1

    if sudo apt-get -qq install $package_name -y >> $LOG_FILE 2>&1; then
        log_success "\t$package_name installed"
        return 0
    else
        ERROR_COUNT=$((ERROR_COUNT+1))
        log_error "\tFailed to install $package_name." >&2
        # show_last_error
        return 1
    fi
}

apt_update() {
    if sudo apt-get -qq update -y >> $LOG_FILE 2>&1; then
        log_success "\tPackage list updated"
        return 0
    else
        log_error "\tFailed to update package list." >&2
        # show_last_error
        return 1
    fi
}

apt_upgrade() {
    if sudo apt-get -qq upgrade -y >> $LOG_FILE 2>&1; then
        log_success "\tPackages upgraded"
        return 0
    else
        log_error "\tFailed to upgrade packages." >&2
        # show_last_error
        return 1
    fi
}

LOG_FILE="log.txt"
if [ -f "$LOG_FILE" ] ; then
    rm "$LOG_FILE"
fi

gum_choose() {
    gum choose --no-limit --cursor.foreground="212" --cursor.bold "$@"
}

gum_message() {
    gum style --bold --foreground="212" "$1" " "
}

gum_question() {
    gum confirm "$1"
}

gum_spin() {
    gum spin --spinner dot --show-output --title "$1" -- bash -c "$2"
}

gum_apt_install() {
    local package_name=$1

    if gum_spin "Installing $package_name..." "sudo apt-get -qq install $package_name -y >> $LOG_FILE 2>&1"; then
        log_success "$package_name installed"
        return 0
    else
        ERROR_COUNT=$((ERROR_COUNT+1))
        log_error "Failed to install $package_name." >&2
        # show_last_error
        return 1
    fi
}


###########################################
# Install Gum and update/upgrade packages #
###########################################

if ! command -v gum &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    apt_update && apt_upgrade && apt_install gum
else
    apt_update && apt_upgrade
fi

###############
# Choose Menu #
###############

choices=$(gum_choose "Install basic packages" \
                     "Configure Git" \
                     "Install VSCode" \
                     "Install GNOME packages" \
                     "Install GTK Dracula theme" \
                     "Install Touchegg" \
                     "Install GNOME Extension Manager" \
                     "Install Kitty terminal" \
                     "Install Fish shell" \
                     "Install Nerd Fonts" \
                     "Install J-Link" \
                     "Install Spotify" \
                     "Install Flutter")

##############################
# Install the basic packages #
##############################

if [[ $choices == *"Install basic packages"* ]]; then
    gum_message "Installing basic packages..."

    gum_apt_install build-essential
    gum_apt_install cmake
    gum_apt_install python3
    gum_apt_install python3-pip
    gum_apt_install python-is-python3
    gum_apt_install git
    gum_apt_install uncrustify
    gum_apt_install curl
    gum_apt_install libusb-1.0-0-dev
    gum_apt_install xclip
    gum_apt_install neofetch
    gum_apt_install cmatrix
    gum_apt_install snapd
    gum_apt_install zip unzip
    gum_apt_install gdb-multiarch
    gum_apt_install vim
    gum_apt_install openocd
    gum_apt_install bat
    gum_apt_install exa
    gum_apt_install tree
    gum_apt_install fzf
    gum_apt_install fd-find
    gum_apt_install btop
    gum_apt_install stlink-tools
    gum_apt_install gcc-arm-none-eabi
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    gum_message "Basic packages installed successfully!"
fi

#################
# Configure Git #
#################

if [[ $choices == *"Configure Git"* ]]; then
    gum_message "Git Configuration"

    git_username=$(gum input --prompt "Enter the git username: ")
    git_email=$(gum input --prompt "Enter the git email: ")

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    gum_message "Git configured successfully!"

    if gum_question "Do you want to configure the SSH?" ; then
        ssh-keygen -t ed25519 -C "$git_email"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        xclip -sel clip < ~/.ssh/id_ed25519.pub
        gum_message "SSH configured successfully! The SSH public key was copied to the clipboard!"
    fi
fi

##################
# Install VSCode #
##################

if [[ $choices == *"Install VSCode"* ]]; then
    gum_message "Installing VSCode..."

    sudo apt-get install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y

    gum_message "VSCode installed successfully!"
fi

##########################
# Install GNOME packages #
##########################

if [[ $choices == *"Install GNOME packages"* ]]; then
    gum_message "Installing GNOME packages..."

    gum_apt_install gnome-tweaks
    gum_apt_install gnome-shell-extensions
    gum_apt_install chrome-gnome-shell
    gum_apt_install dconf-editor
    gum_apt_install dconf-cli
fi

#########################
# Install Dracula Theme #
#########################

if [[ $choices == *"Install GTK Dracula theme"* ]]; then
    gum_message "Installing Dracula Theme..."

    if gum_question "Do you want to install GTK Theme?" ;then

        gum_message "Installing GTK Dracula Theme...\n"

        curl -o Dracula.zip -fL https://github.com/dracula/gtk/archive/master.zip
        unzip Dracula.zip
        mkdir -p ~/.themes/Dracula
        cp -r gtk-master/* ~/.themes/Dracula
        rm -rf gtk-master
        rm -f Dracula.zip

        gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
        gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

        gum_message "Installing GTK Dracula Theme installed!\n"

    fi

    if gum_question "Do you want to install Icon Theme?"; then

        gum_message "Installing Icon Dracula Theme...\n"

        curl -fLO https://github.com/dracula/gtk/files/5214870/Dracula.zip
        unzip Dracula.zip
        mkdir -p ~/.icons/Dracula
        cp -r Dracula/* ~/.icons/Dracula
        rm -rf Dracula
        rm -f Dracula.zip

        gsettings set org.gnome.desktop.interface icon-theme "Dracula"

        gum_message "Installing Icon Dracula Theme installed!\n"

    fi

    if gum_question "Do you want to install Gnome Terminal Theme?"; then

        gum_message "Installing Gnome Terminal Dracula Theme...\n"

        git clone https://github.com/dracula/gnome-terminal
        cd gnome-terminal
        ./install.sh
        cd ..
        rm -rf gnome-terminal

        gum_message "Installing Gnome Terminal Dracula Theme installed!\n"

    fi

    if gum_question "Do you want to install Gedit Theme?"; then

        gum_message "Installing Gedit Dracula Theme...\n"

        wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml
        mkdir -p $HOME/.local/share/gedit/styles/
        mv dracula.xml $HOME/.local/share/gedit/styles/

        gum_message "Installing Gedit Dracula Theme installed! Activate in Gedit's preferences dialog.\n"

    fi

    if gum_question "Do you want to install Tela Circle Icons Theme?"; then

        gum_message "Installing Tela Circle Icons Theme...\n"

        git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
        cd Tela-circle-icon-theme
        ./install.sh
        cd ..
        rm -rf Tela-circle-icon-theme

        gum_message "Installing Tela Circle Icons Theme installed!\n"

    fi
fi

####################
# Install Touchegg #
####################

if [[ $choices == *"Install Touchegg"* ]]; then
    gum_message "Installing Touchegg..."

    sudo add-apt-repository ppa:touchegg/stable
    sudo apt update
    sudo apt install touchegg

    gum_message "Touchegg installed successfully!"
fi

#############################
# Install Extension Manager #
#############################

if [[ $choices == *"Install GNOME Extension Manager"* ]]; then
    gum_message "Installing GNOME Extension Manager..."

    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.mattjakeman.ExtensionManager -y

    gum_message "GNOME Extension Manager installed successfully!"
fi

#################
# Install Kitty #
#################

if [[ $choices == *"Install Kitty terminal"* ]]; then
    gum_message "Installing Kitty terminal...\n"

    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    sudo ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/bin/
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50

    gum_message "Kitty terminal installed successfully!\n"
fi

################
# Install Fish #
################

if [[ $choices == *"Install Fish shell"* ]]; then
    gum_message "Installing fish...\n"

    sudo apt-add-repository ppa:fish-shell/release-3 -y
    sudo apt update -y
    sudo apt install fish -y
    sudo echo -e $(which fish) | sudo tee -a /etc/shells
    sudo chsh -s $(which fish)
    chsh -s $(which fish)

    gum_message "Installing Starship..."
    curl -fsSL https://starship.rs/install.sh | sh
    mkdir -p ~/.config/fish/
    gum_message "starship init fish | source" >> ~/.config/fish/config.fish

    curl -sfL https://git.io/fundle-install | fish

    gum_message "Fish installed successfully!\n"
fi

######################
# Install Nerd Fonts #
######################

if [[ $choices == *"Install Nerd Fonts"* ]]; then
    gum_message "Installing Nerd Fonts...\n"

    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFontMono-Bold.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Light/FiraCodeNerdFontMono-Light.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFontMono-Medium.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Retina/FiraCodeNerdFontMono-Retina.ttf
    curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFontMono-SemiBold.ttf
    
    gum_message "Nerd Fonts installed successfully!\n"
fi

##################
# Install J-Link #
##################

if [[ $choices == *"Install J-Link"* ]]; then
    gum_message "Installing J-Link...\n"

    cd
    curl -fLO -d 'accept_license_agreement=accepted&submit=Download+software' https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb
    sudo apt install ./JLink_Linux_x86_64.deb -y
    rm JLink_Linux_x86_64.deb

    gum_message "J-Link installed successfully!\n"
fi

###################
# Install Spotify #
###################

if [[ $choices == *"Install Spotify"* ]]; then
    gum_message "Installing Spotify...\n"

    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update -y && sudo apt-get install spotify-client -y

    gum_message "Spotify installed successfully!\n"
fi

###################
# Install Flutter #
###################

if [[ $choices == *"Install Flutter"* ]]; then
    gum_message "Installing Flutter...\n"
    
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

    gum_message "Flutter installed successfully!"
    gum_message "Remember to install cmd line tools in Android Studio!"
fi

##########################
# Install STM32 Software #
##########################

echo -e "\nFor installing the STM32 Software, follow the instructions in the link below:\n"
echo -e "\tSTM32CubeProgrammer: https://www.st.com/en/development-tools/stm32cubeprog.html"
echo -e "\tSTM32CubeMX: https://www.st.com/en/development-tools/stm32cubemx.html"
echo -e "\tSTM32CubeMonitor: https://www.st.com/en/development-tools/stm32cubemonitor.html"

# If there was an error, show the log file

if [ $ERROR_COUNT -gt 0 ]; then
    log_error "There were $ERROR_COUNT errors. Check the log file for more information."
    cat $LOG_FILE
fi



