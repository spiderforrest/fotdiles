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

# history configs
export HISTCONTROL=ignoreboth
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
HISTFILESIZE=-1

# autocomplete after sudo, man, so on
complete -cf sudo
complete -cf man
complete -cf which
complete -cf progflip

# sourcing
if [[ -f "$HOME/.config/herbstluftwm/share/herbstclient-completion.bash" ]] ; then
    source "$HOME/.config/herbstluftwm/share/herbstclient-completion.bash"
fi
if [[ -f "$HOME/project/git/qmk_firmware/util/qmk_tab_complete.sh" ]] ; then
    source "$HOME/project/git/qmk_firmware/util/qmk_tab_complete.sh"
fi


### functions ###


# history but less obnoxious
hst() {
    if [[ -n "$1" ]] ; then
        cat -n "$HOME/.bash_history" | grep -a "$1" | tail -n 40
    else
        history | tail -n 40
    fi
}

# touch grass or something
cfg() {
    if [[ -z "$1" ]] ; then return; fi
    dir="$HOME/.config"
    case "$1" in
        bash* | sh*)        nvim "$HOME/.bashrc"                    ;;
        term* | wez*)       nvim "$dir/wezterm/wezterm.lua"         ;;
        red | redshift | ow)nvim "$dir/redshift/redshift.conf"      ;;
        i3)                 nvim "$dir/i3/config"                   ;;
        picom)              nvim "$dir/picom/picom.conf"            ;;
        bin | script*)      nvim "$HOME/bin/$2"                     ;;
        v* | nvim)
            if [[ -z "$2" ]] ; then
                          nvim "$dir/nvim/nvim.lua"
            else
                          nvim "$dir/nvim/$2.lua"
            fi                                                      ;;
        # idk it's probably awesome
        wm | awesome | *)
            if [[ -z "$2" ]] ; then
                            nvim "$dir/awesome/rc.lua"
            else
                            nvim "$dir/awesome/$2.lua"
            fi                                                      ;;
    esac
}

# git gud
shove() {
    # check if i'm just in my home dir
    if [[ "$PWD" == "$HOME" ]] ; then
        yadm pull
        yadm add -u
        yadm status
        if [[ "$1" ]] ; then
            echo '/// fr? ///'
            read -r
            yadm commit -m "$*"
            yadm push
            return
        fi
        echo "/// add a commit message ///"
        read -r message
        yadm commit -m "$message"
        yadm push
        return
    fi
    git pull
    git add -A
    git status
    if [[ "$1" ]] ; then
        echo '/// continue? ///'
        if git status | grep -q main ; then
            echo '/// and you'\''re on main you nincompoop ///'
        fi
        read -r
        git commit -m "$*"
        git push
        return
    fi
    echo '/// so help me god if you put something lazy ///'
    if git status | grep -q main ; then
        echo '/// and you'\''re on main you nincompoop ///'
    fi
    read -r message
    git commit -m "$message"
    git push
}
# shorthand to clone down a github repo with minimal link format
github() {
    if [[ -z $1 ]] ; then return ; fi
    # shush shellcheck
    if [[ -z "$(pwd | grep git)" ]] ; then
        cd "$HOME/project/git" || return
    fi
    if echo "$1" | grep -q http; then
        git clone "$1"
    else
        git clone "https://github.com/$1.git"
    fi
}

# consolidates ls,cat,mkdir,vim,touch,cd,vim again
uh() {
    # check second arg for edit/enter flag for editing existing files or moving directories-saves me like four keypresses to just append 'v' or 'e' when uh-ing aroud to edit
    if [[ -n "$2" ]] ; then
        if [[  "$2" = "v" || "$2" = "e" ]] ; then
            nvim "$1"
        else
            # run arbitrary command on $1
            shift 1
            "$*" "$1"
        fi
        return
    fi
    # bootleg case statement operating on what the target is
    # ls PWD if no input
    if [[ -z "$1" ]] ; then
        ls -ZlAhcbGNp --color=always --group-directories-first --time-style=+%y/%m/%d\.%H%M --hyperlink=auto | tac
        # ls target if existing dir
    elif [[ -d "$1" ]] ; then
        ls -ZlAhcbGNp --color=always --group-directories-first --time-style=+%y/%m/%d\.%H%M --hyperlink=auto "$1" | tac
        # cat target if textfile
    elif [[ -f "$1" ]] ; then
        cat "$1"
        # the shellcheck warning annoys me a lot more than it should
        printf "/// %s ///\n" "$(ls -abhHiluZ --color=always --group-directories-first --time-style=+%y/%m/%d\.%H%M --hyperlink=auto "$1" | tac)"
        # make directory or make/edit file
    elif [[ ! -e "$1" ]] ; then
        printf "/// does not exist! create \"%s\" as a directory open a new file ///\n  for editor(assumed): *\n  for mkdir: d(irectory),m(kdir)\\n  for touch: t(ouch)\\n  cancel: n(o),c(ancel)\n" "$1"
        read -r i
        case "$i" in
            n* | c*)	return								;;
            d* | m*)	mkdir -p "$1" && cd "$1" || return	;;
            t*)         touch "$1"                          ;;
            *)			nvim "$1"							;;
        esac
    fi
}

# extract script bc fuck remembering that
extract() {
    case "$1" in
        *.tar.bz2)   tar xvjf "$1"				;;
        *.tar.gz)    tar xvzf "$1"				;;
        *.bz2)       bunzip2 "$1" 				;;
        *.rar)       unrar x "$1" 				;;
        *.gz)        gunzip "$1"  				;;
        *.tar)       tar xvf "$1" 				;;
        *.tbz2)      tar xvjf "$1"				;;
        *.tgz)       tar xvzf "$1"				;;
        *.zip)       unzip "$1"   				;;
        *.Z)         uncompress "$1"			;;
        *.7z)        7z x "$1"					;;
        *) echo "that's unknownski my broski" 	;;
    esac
}

### aliasi ###

# shorthands
alias v='nvim'
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
alias fork="alacritty & disown"


# fixes/improvements
alias sl='sl -la'
alias rm='rm -rI'
alias grep='grep --color=auto'
alias btop='btop --utf-force'
# alias sudo !!
alias !='sudo /bin/bash -c "$(history -p !!)"'
# allow aliasi to apply after sudo
alias sudo="/bin/sudo "
# some files start with a bit of garbo bytes, grep misbehaves to protect output but i ain't a pussy
alias grep='grep -a'

# bedrock aliasi
if [[ -d /bedrock ]] ; then
    alias stvoidm='strat -r void-musl'
    alias stvoid='strat -r void'
    alias starch='strat -r arch'
    alias stalp='strat -r alpine'
    alias stubu='strat -r ubuntu'
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
trap 'echo -ne "\033]2;$TERM | $(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG
#EOF
