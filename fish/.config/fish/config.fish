function fish_mode_prompt
  switch $fish_bind_mode
    case default
      echo -en "\e[2 q"
    case insert
      echo -en "\e[6 q"
    case replace_one
      echo -en "\e[4 q"
    case visual
      echo -en "\e[2 q"
    case '*'
      echo -en "\e[2 q"
  end
  set_color normal
end

set fish_greeting
fish_mode_prompt

# FROM ZSH CONFIG

set -x WM "i3-gaps"

command -v rockfetch > /dev/null && rockfetch


#alias vim="nvim"
alias ale="ssh sec@start.massinoviello.xyz"
alias rainbow="figlet loooool coglione"
alias magicctl="figlet wooooosh | lolcat"
alias magictl="figlet wooooosh | lolcat"
alias vi="nvim"
alias pi="sshpass -p 1 ssh pi@192.168.1.15"
alias ls="ls --color"
alias sl="ls --color"
alias em="emacs -nw"
alias a="junest --"


command -v dnf5 > /dev/null && alias dnf='sudo dnf5'


bind \cs __fish_prepend_sudo

set TERM "xterm-256color"

set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_visual underscore

set PATH $HOME/.rvm/bin $PATH
set PATH $HOME/gits/v $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/go/bin $PATH
set PATH $HOME/go/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.dotnet $PATH
set PATH $HOME/.local/share/junest/bin $PATH
set PATH $HOME/.nimble/bin $PATH
set PATH $HOME/.local/bin $PATH

set PATH /usr/local/sbin $PATH
set PATH /usr/local/bin $PATH
set PATH /usr/bin $PATH
set PATH /usr/sbin $PATH
set PATH /sbin $PATH
set PATH /bin $PATH
set PATH /opt/texlive/2020/bin/x86_64-linux $PATH
set PATH /usr/lib/ruby/gems/2.7.0/bin $PATH

#bass source /etc/profile


set GIT_ASKPASS "/hdd/gittoken"

set VISUAL "nvim"
set EDITOR $VISUAL

#export PATH="$PATH:/home/sec/.bins/flutter/bin"
#export PATH="$PATH:/home/sec/GeneratorFabricMod/bin"
#export PATH="$PATH:/home/sec/.gem/ruby/2.7.0/bin"
#export PATH="$PATH:/opt/android-sdk/tools/bin"
#export PATH="$PATH:/opt/android-sdk/platform-tools"
#export PATH="$PATH:/opt/android-sdk/build-tools/30.0.2"
#export PATH="$PATH:/opt/android-sdk/tools/bin"
#export PATH="$PATH:/opt/android-sdk/emulator"

#export ANDROID_SDK_ROOT="/opt/android-sdk"
