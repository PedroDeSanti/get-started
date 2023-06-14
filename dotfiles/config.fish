if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init starship
starship init fish | source

set fish_greeting

alias cube='/usr/local/STMicroelectronics/STM32Cube/STM32CubeMX/STM32CubeMX'
alias cube_programmer='/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32CubeProgrammer'

alias thunder='cd /home/santi/Documentos/ThundeRatz'

# set -x ARM_GCC_PATH /home/santi/Programas/arm-gcc/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin
set -x ARM_GCC_PATH /home/santi/Programas/arm-gcc/gcc-arm-none-eabi-10.3-2021.10/bin
set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX
set -x CUBE_PROGRAMMER_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin

set PATH $PATH $ARM_GCC_PATH
set PATH $PATH $CUBE_PROGRAMMER_PATH
