#!/usr/bin/env bash

flutter_deps=(
    curl git unzip xz-utils zip libglu1-mesa
)

install_flutter() {
    show_message "Installing Flutter..."
    
    require_apt_packages "${flutter_deps[@]}" || return

    snap_install "android-studio --classic" || return
    snap_install "flutter --classic" || return

    show_message "Launching Android Studio to install the Android SDK..."
    show_message "Please follow the instructions in Android Studio to install the Android SDK." \
                 "1. Follow the setup wizard and wait for the installation to complete" \
                 "2. Go to More Actions > SDK Manager" \
                 "4. Under SDK Tools, check 'Android SDK Command-line Tools' and click Apply" \
                 "5. Wait for the installation to complete" \
                 "6. Close Android Studio to proceed with script execution"

    android-studio 2>&1 | log_output

    show_message "Android Studio closed. Proceeding with Flutter setup..."

    flutter config --android-sdk="$HOME"/Android/Sdk 2>&1 | log_output || {
        log_warning "Failed to configure Flutter with Android SDK"
    }

    yes | flutter doctor --android-licenses 2>&1 | log_output || {
        log_warning "Failed to accept Android licenses"
    }

    flutter doctor

    show_message "Flutter installation complete!"
}