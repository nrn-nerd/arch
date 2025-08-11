#
# ~/.bashrc
#

export QT_QPA_PLATFORMTHEME=gtk2
export GTK_THEME=Adwaita-dark
export XCURSOR_THEME=Bibata-Modern-Ice
export XCURSOR_SIZE=20


eval "$(starship init bash)"
# fastfetch
export STARSHIP_CONFIG=~/.config/starship.toml
sed -i 's|home/.*|home/'"$(whoami)"'\"|g' ~/.config/starship.toml




# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export GOOGLE_CLOUD_PROJECT=global-sign-468521-b1
export GOOGLE_CLOUD_PROJECT=global-sign-468521-b1


alias rm='trash-put'
