#!/bin/bash

# spider's unified ~/.bashrc

### setup/misc ###

# i want these to be available in non-interactive enviorments
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export EDITOR=nvim
export pref_term="wezterm"

# ignore the rest if not interactive
[[ $- != *i* ]] && return

# this redirects to hilbish when interactive, on legsix, and when the parent process is NOT hilbish
# so if you type bash in hilbish you get bash
# can you breathe shellcheck
# shellcheck disable=SC2009,SC2143
if [[ "$HOSTNAME" == "spiderlegsix" ]] && ! ps $PPID | grep -q hilbish ; then
  exec hilbish -S -l
fi

# history configs
export HISTCONTROL="ignoreboth"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
HISTFILESIZE=-1

# autocomplete after sudo, man, so on
complete -cf sudo
complete -cf man
complete -cf which
complete -cf progflip

### functions ###
# moved to bin as dedicated scripts


### aliasi ###

# shorthands
alias v='nvim'
alias vw='nvim "+lua writing()"' # it feels real good changing that to a lua funtion call oooooooo
alias ni='neovide --multigrid'
alias suv='sudoedit'
alias chkdns='ping 8.8.8.8'
alias la='ls -Bbp1 -gah --group-directories-first --time-style=+%b\ %d --color=auto --hyperlink=auto'
alias ls='ls -BNp1 --group-directories-first --color=auto --hyperlink=auto'
alias ch='chore'
alias godo='chore'
alias gitfix='sed -i s/mindforrest/spiderforrest/ */.git/config'
alias binfix='chmod +x ~/bin/*'
alias fastread='fsrx'
alias serv='ssh spider@spood.org -p 773'
alias fserv='sftp -P 773 spider@spood.org'
alias why_would_you_do_this_dude_why='xclip -o | shuf'
alias :q="exit" # ...
alias xmpp="profanity -a spider@spood.org -t boothj5_slack"
# shellcheck disable=SC2139
alias cold="notify-send 'Numen dormant' && numen $HOME/.config/numen/off.phrases"
# shellcheck disable=SC2139
alias nile="$HOME/project/git/nile/bin/nile"
nuke() { rm -r "$1" && echo "rm -r\"\$*\" \"./$1\"" >> "$HOME/bin/clean_junk"; }
alias prosody="TERM=xterm ssh -J spood.org:773 admin@xmpp.spood.org -i .aws/spider.pem"
alias mine="__GL_THREADED_OPTIMIZATIONS=0 multimc -l 'the final gay'"

# fixes/improvements
alias sl='sl -la'
alias rr='rm -rI'
alias grep='grep --color=auto'
alias btop='btop --utf-force'
# alias sudo !!
alias !='sudo /bin/bash -c "$(history -p !!)"'
# allow aliasi to apply after sudo
alias sudo="/bin/sudo "
# some files start with a bit of garbo bytes, grep misbehaves to protect output but i ain't a pussy
alias grep='grep -a'
restore() {
  if [[ "$1" -eq "sudo" ]] ; then
  sudo cp "/mnt/legsix/$2" "$2"
  else
  cp "/mnt/legsix/$1" "$1"
  fi
}

# bedrock aliasi
if [[ -d /bedrock ]] ; then
    alias stvoidm='strat -r void-musl'
    alias stvoid='strat -r void'
    alias stvoidg='strat -r void-glibc'
    alias starch='strat -r arch'
    alias stalp='strat -r alpine'
    alias stubu='strat -r ubuntu'
    alias stdeb='strat -r debian'
    alias brw='brl which'
    export st=/bedrock/strata/ # shorthand for directly accessing strata-e.g. ls $st/void/etc (even works with tab complete tank u bash)
fi

# device specific
case "$HOSTNAME" in
    avoidroof)
        PS1='\[\e[0;34m\]avoidbelow \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
        alias printsync='sudo mount /dev/sdb1 /mnt && echo "mounted" && sudo cp /home/spider/Documents/printer/* /mnt && echo "copied" && sudo umount /dev/sdb1 && echo "unmounted"'
        alias jardour='pw-jack ardour6'
        alias engrish='cat ~/wordlist | grep -w ' # 's not cat abuse, i'd have to make a funtion to not use cat
        alias hyper='stvoid /home/spider/bin/hyperbeam --no-sandbox'
        # weird fix for glibc qutebrowser on musl-void init/(dm)/xorg stack
        export QT_XCB_GL_INTEGRATION=none
        ;;

    spiderlegthree)
        PS1='\[\e[0;34m\]thirdleg \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
        alias hyper='stvoid /home/spider/bin/hyperbeam --no-sandbox'
        alias keeb='cd $HOME/project/git/qmk_firmware/keyboards/lily58/keymaps/spiderforrest/ && git status'
        # weird fix for glibc qutebrowser on musl-void init/(dm)/xorg stack
        export QT_XCB_GL_INTEGRATION=none
        ;;

    waputer)
        PS1="\[\e[0;32m\]waputer \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]"
        alias shutdown='sudo shutdown'
        alias reboot='sudo reboot'
        alias nmtui='sudo nmtui'
        ;;
    # rip will be rembered
    fizzbox | spiderlegsix)
        PS1="\[\e[0;32m\]spiderlegsix \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]"
        alias sound='spotify & disown && lyrics'
        alias keeb='cd $HOME/project/git/qmk_firmware/keyboards/lily58/keymaps/spiderforrest/ && git status'
        alias pay='hledger iadd'
        export LEDGER_FILE="$HOME/misc/profit/hledger.journal"
        ;;

    bedbox | spiderlegtwo)
        PS1='\[\e[0;31m\]thespoodbox \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
        alias share='sudo chmod 777 -R /share'
        alias pay='hledger iadd'
        alias mine='cd /home/mine && sudo su mine && cd -' # I'm so fancy
        alias legsix='ssh 192.168.0.17'
        export LEDGER_FILE="$HOME/misc/profit/hledger.journal"
        echo
        neofetch
        echo
        who
        echo
        ps aux | sort -grk6 | head -n 5
        ;;
esac

# less color spam
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# attempt to set the terminal title
trap 'echo -ne "\033]2;$TERM - $(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG

#EOF
