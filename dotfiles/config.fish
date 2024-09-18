if status is-interactive
    # Commands to run in interactive sessions can go here
end

# init starship
starship init fish | source

# init zoxide
zoxide init fish | source

# Remove welcome message
# set fish_greeting

function fish_greeting
    # echo Hello friend!
    # echo The time is (set_color yellow; date +%T; set_color normal) and this machine is called $hostname
end


#########################
# Environment Variables #
#########################

# set -x ARM_GCC_PATH $HOME/Programas/arm-gcc/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin
set -x ARM_GCC_PATH /opt/arm-none-eabi/gcc-arm-none-eabi-10.3-2021.10/bin
set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX
# set -x CUBE_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX_6.4.0
set -x CUBE_PROGRAMMER_PATH /usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin
set -x ANDROID_HOME $HOME/Android/Sdk # Flutter

# set EDITOR to code
set -x EDITOR /usr/bin/code

# set -x TERM_PROGRAM kitty

set PATH $PATH $ARM_GCC_PATH
set PATH $PATH $CUBE_PROGRAMMER_PATH
set PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin
set PATH $PATH $ANDROID_HOME/platform-tools


abbr cube '$CUBE_PATH/STM32CubeMX'
abbr cube_programmer '$CUBE_PROGRAMMER_PATH/STM32CubeProgrammer'

abbr thunder 'cd $HOME/Documentos/ThundeRatz'

abbr update 'sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh && flatpak update -y && flatpak remove --unused' -y
abbr cp-path 'pwd;pwd | xclip -selection clipboard'
abbr cp-to-clipboard 'xclip -selection clipboard'

abbr config-fish        '$EDITOR ~/.config/fish/config.fish'
abbr config-starship    '$EDITOR ~/.config/starship.toml'
abbr config-kitty       '$EDITOR ~/.config/kitty/kitty.conf'
abbr config-ranger      '$EDITOR ~/.config/ranger/rc.conf'
abbr config-awesome     '$EDITOR ~/.config/awesome/rc.lua'
abbr config-picom       '$EDITOR ~/.config/picom/picom.conf'

abbr redirect_port 'ssh -o IdentitiesOnly=yes -i ~/.ssh/pedrosanti.first pedrosanti.first@pedrosanti-43268.portmap.io -N -R 43268:localhost:1883'

abbr my-ip "hostname -I | awk '{print \$1}'"

abbr stm32guide 'open https://github.com/ThundeRatz/STM32Guide'

abbr gcm 'git commit -m'
abbr pull 'git pull'
abbr push 'git push'
abbr stash 'git stash'
abbr clean-branches 'git fetch -p && git branch --merged | grep -v \* | xargs git branch -D'

abbr gazebo 'ign gazebo'

abbr clr 'clear'

abbr code. 'code .'

abbr cmake.. 'cmake ..'

abbr logout 'sudo pkill -u $USER'

abbr ls 'exa --icons --color=always'

abbr cd.. 'cd ..'

alias bat='batcat'

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

function ws
    set workspace $argv[1]
    set command $argv[2..-1]

    # Run the ~/Scripts/workspace.sh script
    ~/Scripts/workspace.sh $workspace

    # set primary monitor
    wmctrl -o 0,0

    eval $command
end

function remake
    # check if current working directory is a build directory
    set var (string split -- / $PWD)[-1]

    if test $var = "build"
        echo "Current directory is a build directory, removing and recreating it"
        cd .. && rm -rf build && mkdir build && cd build && cmake ..
    else
        echo "Current directory is not a build directory"
    end

end



# Function to wrap the current command line with launch_on_workspace 1
function wrap_with_launch_on_workspace
    set workspace $argv[1]

    # Check if the current command line is empty
    if test -z (commandline)
        return
    end

    # Check if the current command begins with ws
    if string match -q "ws *" (commandline)
        #if the ws number is the same as the current workspace, unwrap
        if string match -q "ws $workspace *" (commandline)
            # echo "Same workspace, unwrapping"
            _unwrap
        else
            # else change the workspace
            set current_command (commandline)
            set new_command (string replace -r "ws [0-9]+ " "ws $workspace " $current_command)
            commandline -r $new_command

        end

        return
    end

    # Get the current command line
    set current_command (commandline)

    # # Wrap the command with launch_on_workspace 1
    set new_command "ws $workspace \"$current_command\""

    # # Replace the current command line with the new command
    commandline -r $new_command
end

function _unwrap
    set current_command (commandline)
    set new_command (string match -r "ws [0-9]+ \"(.*)\"" $current_command)[2]

    commandline -r $new_command
end


# Bind Ctrl+1 to the wrap_with_launch_on_workspace function

bind -k f1 "wrap_with_launch_on_workspace 1"
bind -k f2 "wrap_with_launch_on_workspace 2"
bind -k f3 "wrap_with_launch_on_workspace 3"
bind -k f4 "wrap_with_launch_on_workspace 4"
bind -k f5 "wrap_with_launch_on_workspace 5"
bind -k f6 "wrap_with_launch_on_workspace 6"
bind -k f7 "wrap_with_launch_on_workspace 7"
bind -k f8 "wrap_with_launch_on_workspace 8"
bind -k f9 "wrap_with_launch_on_workspace 9"
bind -k f10 "wrap_with_launch_on_workspace 10"


###########
# Plugins #
###########

fundle plugin 'jorgebucaran/nvm.fish'
fundle plugin 'ilancosman/tide@v6'
fundle plugin 'patrickf1/fzf.fish'
fundle plugin 'jorgebucaran/autopair.fish'
fundle plugin 'nickeb96/puffer-fish'
fundle plugin 'edc/bass'
fundle plugin 'kenji-miyake/auto-source-setup-bash.fish'
fundle plugin 'lig/fish-gitmoji' --url 'https://codeberg.org/lig/fish-gitmoji.git'

fundle init

###############
# Keybindings #
###############

fzf_configure_bindings --directory=\e\cF --variables=\e\cv
# fzf_configure_bindings --directory=\cf --variables=\e\cv

# bind \cF "--type=overlay --stdin-source=@screen_scrollback /usr/local/bin/fzf --no-sort --no-mouse --exact -i"

# asdf elixir/erlang version manager
source ~/.asdf/asdf.fish

bass source /opt/ros/humble/setup.bash
