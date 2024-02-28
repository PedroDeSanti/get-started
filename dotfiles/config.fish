if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init starship
starship init fish | source

# init zoxide
zoxide init fish | source

# Remove welcome message
set fish_greeting


#########################
# Environment Variables #
#########################

# set -x ARM_GCC_PATH /home/santi/Programas/arm-gcc/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin
set -x ARM_GCC_PATH /opt/arm-none-eabi/gcc-arm-none-eabi-10.3-2021.10/bin
set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX
# set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX_6.4.0
set -x CUBE_PROGRAMMER_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin
set -x ANDROID_HOME /home/santi/Android/Sdk # Flutter

# set EDITOR to code
set -x EDITOR /usr/bin/code

# set -x TERM_PROGRAM kitty

set PATH $PATH $ARM_GCC_PATH
set PATH $PATH $CUBE_PROGRAMMER_PATH
set PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin
set PATH $PATH $ANDROID_HOME/platform-tools


abbr cube '$CUBE_PATH/STM32CubeMX'
abbr cube_programmer '$CUBE_PROGRAMMER_PATH/STM32CubeProgrammer'

abbr thunder 'cd /home/santi/Documentos/ThundeRatz'
abbr swarm 'cd /home/santi/Documentos/Swarm'

abbr update 'sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh && flatpak update -y && flatpak remove --unused' -y
abbr cp_path 'pwd;pwd | xclip -selection clipboard'

abbr config_fish 'code /home/santi/.config/fish/config.fish'
abbr config_starship 'code ~/.config/starship.toml'
abbr config_kitty 'code ~/.config/kitty/kitty.conf'

abbr redirect_port 'ssh -o IdentitiesOnly=yes -i ~/.ssh/pedrosanti.first pedrosanti.first@pedrosanti-43268.portmap.io -N -R 43268:localhost:1883'

abbr my_ip "hostname -I | awk '{print \$1}'"

abbr stm32guide 'open https://github.com/ThundeRatz/STM32Guide'

abbr gcm 'git commit -m'

abbr ls 'exa'
# alias ls='exa'

# abbr cd.. 'cd ..'
alias bat='batcat'
# abbr bat 'batcat'
abbr :q 'exit'
abbr :Q 'exit'

#############
# Functions #
#############

# Abre o repositório remoto no navegador
function open-remote
    set origin_url (git remote get-url origin)
    set repo_url (string match -r 'github\.com[:/](.*)\.git' $origin_url)[2]

    set url "https://github.com/$repo_url"

    if test -n "$url"
        echo "Abrindo repositório remoto no navegador: $url"
        open $url
    else
        echo "Não foi possível determinar o link remoto."
    end
end

# Cria um diretório e navega até ele
function take
    mkdir -p $argv
    cd $argv
end

# Clona um repositório Git e navega até o diretório criado
function clone
    git clone $argv
    cd (basename "$argv" .git)
end


# function sudo
#     if functions -q $argv[1]
#         set argv fish -c "$argv"
#     end
#     command sudo $argv
# end

# abbr sudo 'sudo fish -c'

###########
# Plugins #
###########

fundle plugin 'jorgebucaran/nvm.fish'
fundle plugin 'ilancosman/tide@v6'
fundle plugin 'patrickf1/fzf.fish'
fundle plugin 'jorgebucaran/autopair.fish'
fundle plugin 'nickeb96/puffer-fish'
fundle plugin 'edc/bass'
fundle plugin 'lig/fish-gitmoji' --url 'https://codeberg.org/lig/fish-gitmoji.git'

fundle init

###############
# Keybindings #
###############

# nao fununcia
fzf_configure_bindings --directory=\cf
fzf_configure_bindings --variables=\c\sv


source ~/.asdf/asdf.fish
