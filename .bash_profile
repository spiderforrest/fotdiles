#
# ~/.bash_profile
#

export GTK_THEME="Adwaita:dark"
export GTK2_RC_FILE=/usr/share/themes/Arc-Darkest/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE="Adwaita-Dark"
export XDG_RUNTIME_DIR="/run/user/$UID"

[[ -f ~/.bashrc ]] && . ~/.bashrc
