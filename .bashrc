# ~/.bashrc: executed by bash(1) for non-login shells.

alias ls='ls --color'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias last='last -i'

alias grep='grep --color=tty'
alias fgrep='fgrep --color=tty'
alias egrep='egrep --color=tty'

alias update='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoclean && updaterc';

alias updaterc='wget -O ~/bashrc https://raw.githubusercontent.com/plutonic1/bashrc/master/.bashrc && mv ~/bashrc ~/.bashrc && source ~/.bashrc'

alias failure="tail /var/log/auth.log | grep failure"
alias opened="tail /var/log/auth.log | grep opened"

alias vpn="sudo cat /var/log/openvpn | grep 'Learn:\|connection-reset'"

alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test1000.zip'

alias vnc='vncserver :1 -geometry 1600x900 -depth 24'

alias s='apt-cache search $1'
alias i='sudo apt-get install $1'

alias h='history | grep $1'

alias ipp='echo $(wget -qO- http://ipecho.net/plain)'

alias c='curl -F "f:1=<-" ix.io'

alias last10='find . -type f -printf "%C+ %p\n" | sort -rn | head -n 10'

#alias g++='g++ -Wredundant-decls -Wcast-align -Wmissing-declarations -Wmissing-include-dirs -Wswitch-enum -Wswitch-default -Wextra -Wall -Werror -Winvalid-pch -Wredundant-decls -Wformat=2 -Wmissing-format-attribute -Wformat-nonliteral -std=c++0x'

# colored manpages
if $_isxrunning; then
	export PAGER=less
	export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
	export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
	export LESS_TERMCAP_me=$'\E[0m'           # end mode
	export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
	export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
	export LESS_TERMCAP_ue=$'\E[0m'           # end underline
	export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi

geo() {
	curl "https://maps.googleapis.com/maps/api/browserlocation/json?browser=firefox&key=AIzaSyDBgL8fm9bD8RLShATOLI1xKmFcZ4ieMkM&sensor=true" --data-urlencode "`nmcli -f SSID,BSSID,SIGNAL dev wifi list |perl -ne "if(s/^(.+?)\s+(..:..:..:..:..:..)\s+(.+?)\s*$/&wifi=mac:\2|ssid:\1|ss:\3/g){print;}"`"
}

set_random_wallpaper() {
	file=$(find ~/Bilder/ -regex '.*\.\(jpg\|png\|jpeg\)' | grep -v Smartphone | shuf -n 1)
	hsetroot -cover "$file"
}

key() {
	gpg --keyserver pgpkeys.mit.edu --recv-key $1
	gpg -a --export $1 | sudo apt-key add -
}

r() {
	echo reboot in ...
	
	for i in {5..1}
	do 
		echo -e "$i"
		sleep 1
	done
	reboot && exit
}

p() {
	echo poweroff in ...

	for i in {10..1}
	do 
		echo -e "$i"
		sleep 1
	done
	poweroff && exit
}

k() {
	if ! screen -list | grep -q "kopierscreen"; then
		screen -S kopierscreen -T xterm
	else
		screen -rx kopierscreen
	fi
}

extract() {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar x -kb $1 ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
			*.tgz)       tar xvzf $1    ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*.xz)         tar --xz -xvf $1;;
			
			*)           echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}
 
shopt -q -s cdspell
unset MAILCHECK

file="/usr/bin/atom"
if [ -f "$file" ]
then
	export VISUAL=atom
else
	export VISUAL=nano
fi

export LANG=de_DE.UTF-8
#export LC_ALL=de_DE.UTF-8
#export LANGUAGE=de_DE.UTF-8
 

LS_COLORS='di=36:ln=32:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43':
export LS_COLORS

Decoration1="\[\e[90m\]╔["
RegularUserPart="\[\e[36m\]\u"
RootUserPart="\[\e[31;1m\]\u\[\e[m\]"
Between="\[\e[37m\]@"
HostPart="\[\e[92m\]\h:"
PathPart="\[\e[93;1m\]\w"
Decoration2="\[\e[90m\]]\n╚>\[\e[m\]"
case `id -u` in
    0) export PS1="$Decoration1$RootUserPart$Between$HostPart$PathPart$Decoration2# ";;
    *) export PS1="$Decoration1$RegularUserPart$Between$HostPart$PathPart$Decoration2$ ";;
esac
