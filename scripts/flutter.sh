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

    android-studio >> "$LOG_FILE" 2>&1

    show_message "Android Studio closed. Proceeding with Flutter setup..."

    # Configure Flutter
    flutter config --android-sdk="$HOME"/Android/Sdk
    flutter config --android-studio-dir=/snap/android-studio/current
    yes | flutter doctor --android-licenses
    flutter doctor

    show_message "Flutter installation complete!"
}