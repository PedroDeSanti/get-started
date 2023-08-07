if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init starship
starship init fish | source

# Remove welcome message
set fish_greeting

alias cube='/usr/local/STMicroelectronics/STM32Cube/STM32CubeMX/STM32CubeMX'
# alias cube='/usr/local/STMicroelectronics/STM32Cube/STM32CubeMX_6.4.0/STM32CubeMX'
alias cube_programmer='/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32CubeProgrammer'

alias thunder='cd /home/santi/Documentos/ThundeRatz'
alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh'
alias cp_path='pwd;pwd | xclip -selection clipboard'
alias config_fish='gedit /home/santi/.config/fish/config.fish'

# set -x ARM_GCC_PATH /home/santi/Programas/arm-gcc/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin
set -x ARM_GCC_PATH /opt/arm-none-eabi/gcc-arm-none-eabi-10.3-2021.10/bin

set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX
# set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX_6.4.0
set -x CUBE_PROGRAMMER_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin

set PATH $PATH $ARM_GCC_PATH
set PATH $PATH $CUBE_PROGRAMMER_PATH

# Flutter
set -x ANDROID_HOME /home/santi/Android/Sdk

set PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin
set PATH $PATH $ANDROID_HOME/platform-tools