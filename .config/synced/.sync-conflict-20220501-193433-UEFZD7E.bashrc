# spider's unified ~/.bashrc

### setup/misc ###

# ignore .bashrc if not interactive
[[ $- != *i* ]] && return
# add directories to $PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=nvim

# history configs
export HISTCONTROL=ignoreboth
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
HISTFILESIZE=5000000

# autocomplete after sudo
complete -cf sudo

# sourcing
if [[ -f "$HOME/.config/herbstluftwm/share/herbstclient-completion.bash" ]] ; then
	source "$HOME/.config/herbstluftwm/share/herbstclient-completion.bash"
fi
if [[ -f "$HOME/git/qmk_firmware/util/qmk_tab_complete.sh" ]] ; then
	source "$HOME/git/qmk_firmware/util/qmk_tab_complete.sh"
fi

### functions ###

# attemps to loop command in the laziest, tackiest way possible
try() {
while true; do
	"$1"
done
}

# history but less obnoxious
hst() {
	if [[ -n "$1" ]] ; then
		history | grep "$1" | tail -n 40
	else
		history | tail -n 40
	fi
}

# consolidates ls,cat,mkdir,vim(as touch),cd,vim again
uh() {
	# check second arg for edit/enter flag for editing existing files or moving directories-saves me like four keypresses to just append 'v' or 'e' when uh-ing aroud to edit
	if [[  "$2" = "v" || "$2" = "e" ]] ; then
		if [[ -e "$1" ]] ; then
			if [[ -f "$1" ]] ; then
				nvim "$1"
			elif [[ -d "$1" ]] ; then
				cd "$1" &&
				return
			fi
		fi
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
		cat -n "$1"
		printf "/// %s ///\n" "$(ls -abhHiluZ --color=always --group-directories-first --time-style=+%y/%m/%d\.%H%M --hyperlink=auto "$1" | tac)"
	# make directory or make/edit file
	elif [[ ! -e "$1" ]] ; then
		printf "/// does not exist! create \"%s\" as a directory or open a new file in editor? ///\n  for editor(assumed): *\n  for mkdir: d(irectory),m(kdir)\\n  cancel: n,c\n" "$1"
		read -r i
		case "$i" in
			n* | c*)	return								;;
			d* | m*)	mkdir -p "$1" && cd "$1" || exit	;;
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
alias vw="nvim -u $HOME/.config/synced/writing.vim"
alias chkdns='ping 8.8.8.8'
alias la='ls -Bbp1 -gah --group-directories-first --time-style=+%b\ %d --color=auto --hyperlink=auto'
alias ls='ls -BNp1 --group-directories-first --color=auto --hyperlink=auto'
alias ch='chore'
alias godo='chore'

# fixes/improvements
alias rm='rm -rI'
alias grep='grep --color=auto'
alias btop='btop --utf-force'
# alias sudo !!
alias !='sudo /bin/bash -c "$(history -p !!)"'
# allow aliasi to apply after sudo
alias sudo="/bin/sudo "

# bedrock aliasi
if [[ -d /bedrock ]] ; then
	alias stvoidm='strat -r void-musl'
	alias stvoid='strat -r void'
	alias starch='strat -r arch'
	alias stalp='strat -r alpine'
	alias brw='brl which'
fi

# device specific
case "$HOSTNAME" in 
	avoidroof)
		PS1='\[\e[0;34m\]avoidbelow \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
		alias printsync='sudo mount /dev/sdb1 /mnt && echo "mounted" && sudo cp /home/spider/Documents/printer/* /mnt && echo "copied" && sudo umount /dev/sdb1 && echo "unmounted"'
		alias jardour='pw-jack ardour6'
		alias engrish='cat ~/wordlist | grep -w ' # 's not cat abuse, i'd have to make a funtion to not use cat
		alias hyper='stvoid /home/spider/bin/hyperbeam --no-sandbox'
		alias sound="spotifyd --no-daemon -p 'alliewants2!girls' -u 'mindforrest' & disown && spotify-tui"
		alias serv='ssh spider@spood.org -p 773'
		alias fserv='sftp spider@spood.org -P 773'
		# weird fix for glibc qutebrowser on musl-void init/(dm)/xorg stack
		export QT_XCB_GL_INTEGRATION=none
	;;

	spiderlegthree)
		PS1='\[\e[0;34m\]thirdleg \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
		alias hyper='stvoid /home/spider/bin/hyperbeam --no-sandbox'
		alias sound="spotifyd --no-daemon -p 'alliewants2!girls' -u 'mindforrest' & disown && spotify-tui"
		alias serv='ssh spider@spood.org -p 773'
		alias fserv='sftp spider@spood.org -P 773'
		# weird fix for glibc qutebrowser on musl-void init/(dm)/xorg stack
		export QT_XCB_GL_INTEGRATION=none

	;;

	fizzbox)
		PS1="\[\e[0;32m\]emma's fizzbox \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]"
		alias serv='ssh spider@192.168.0.61 -p 773'
		alias fserv='sftp spider@spood.org -P 773'
		alias sound='spotify & disown && lyrics'
		alias keeb='cd /home/emily/git/qmk_firmware/keyboards/lily58/keymaps/mindforrestDark/'
        alias pay='hledger iadd'
        export LEDGER_FILE="$HOME/misc/profit/hledger.journal"
	;;

	bedbox)
		PS1='\[\e[0;31m\]thespoodbox \[\e[0m\]@ \[\e[0;36m\]\w \[\e[0m\]\$ \[\e[0m\]'
		alias share='sudo chmod 777 -R /share'
		alias whee='discord-chat-exporter-cli export --channel 804103552918224896 -f PlainText -o "$HOME/storage/nieVent/$(date) -t'
        alias pay='hledger iadd'
        export LEDGER_FILE="$HOME/misc/profit/hledger.journal"
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

#EOF
