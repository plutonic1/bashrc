if [ $TERM != 'dumb'  ]
then
	echo "bashrc version 0.5c"
	export TERM=xterm #tmux workaround
fi

if uname -a | grep -qv "cyanogenmod";	then
	alias ls='ls --color'
	alias ll='ls $LS_OPTIONS -l'
	alias l='ls $LS_OPTIONS -lA'
	alias last='last -i'

	alias grep='grep --color=tty'
	alias fgrep='fgrep --color=tty'
	alias egrep='egrep --color=tty'
fi

alias vpn="sudo grep 'Learn:\|connection-reset' /var/log/openvpn"

alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test1000.zip'

alias vnc='vncserver :1 -geometry 1600x900 -depth 24'

alias h='history | grep $1'

alias ipp='echo $(wget -qO- http://ipecho.net/plain)'

alias ix='curl -F "f:1=<-" ix.io'

alias last10='find . -type f -printf "%C+ %p\n" | sort -rn | head -n 10'

alias a='tmux a'

#taken from http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

alias mount='mount | column -t'

# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


if uname -a | grep -qv "cyanogenmod";	then
    # http://superuser.com/questions/137438/how-to-unlimited-bash-shell-history
    # Eternal bash history.
    # ---------------------
    # Undocumented feature which sets the size to "unlimited".
    # http://stackoverflow.com/questions/9457233/unlimited-bash-history
    export HISTFILESIZE=
    export HISTSIZE=
    export HISTTIMEFORMAT="[%F %T] "
    # Change the file location because certain bash sessions truncate .bash_history file upon close.
    # http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
    export HISTFILE=~/.bash_eternal_history
    # Force prompt to write history after every command.
    # http://superuser.com/questions/20900/bash-history-loss
    PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
fi

if [ -f ".aliases" ];
then
    . .aliases
fi

s(){
	if which apt-cache &> /dev/null; then
		apt-cache search $1
	elif which pacman &> /dev/null; then
		pacman -Ss $1
	fi
}

i(){
	#if which apt-get &> /dev/null; then
		#sudo apt-get install $*
    if which apt &> /dev/null; then
        $(which sudo) apt install $* #hack for termux
	elif which pacman &> /dev/null; then
		sudo pacman -S $*
	fi
}

update() {
	if which apt &> /dev/null; then
        if which sudo &> /dev/null; then
            sudo apt update -y
            sudo apt upgrade -y
            #sudo apt autoclean
        else
            apt update -y
            apt upgrade -y
            #apt autoclean
        fi
        updaterc
    elif which apt-cyg &> /dev/null; then
        apt-cyg update
        updaterc
    elif which apt-get &> /dev/null; then
        #sudo apt-get update -y
        #sudo apt-get upgrade -y
        #sudo apt-get autoclean
        #updaterc
        false #only to prevent a syntax error
    elif which pacman &> /dev/null; then
        yaourt -Syu --aur
        updaterc
	fi
}

updaterc() {
	if which curl &> /dev/null; then
			rm ~/.bashrc
			curl https://raw.githubusercontent.com/plutonic1/bashrc/master/.bashrc > ~/.bashrc
			. ~/.bashrc
		elif which wget &> /dev/null; then
			rm ~/.bashrc
			wget -O ~/.bashrc https://raw.githubusercontent.com/plutonic1/bashrc/master/.bashrc
			. ~/.bashrc
		else
			echo "no download tool found"
	fi
}


geo() {
	curl "https://maps.googleapis.com/maps/api/browserlocation/json?browser=firefox&key=AIzaSyDBgL8fm9bD8RLShATOLI1xKmFcZ4ieMkM&sensor=true" --data-urlencode "`nmcli -f SSID,BSSID,SIGNAL dev wifi list | perl -ne "if(s/^(.+?)\s+(..:..:..:..:..:..)\s+(.+?)\s*$/&wifi=mac:\2|ssid:\1|ss:\3/g){print;}"`"
}

key() {
	gpg --keyserver pgpkeys.mit.edu --recv-key $1
}

r() {
	echo reboot in ...

	for i in {5..1}
	do
		echo -e "$i"
		sleep 1
	done
	sudo reboot && exit
}

p() {
	echo poweroff in ...

	for i in {10..1}
	do
		echo -e "$i"
		sleep 1
	done
	sudo poweroff && exit
}

k() {
	if ! tmux ls | grep -q "copy"; then
		tmux new -s copy
	else
		tmux a -t copy
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
			*.xz)        tar --xz -xvf $1;;

			*)           echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

encrypt(){
  echo -e "\e[91mhandle with care! original file will be shredded\e[0m"
	if openssl aes-256-cbc -a -salt -in $1 -out $1.encrypt; then
    shred -f --zero $1
    rm -f $1
  fi
}

decrypt(){
  echo -e "\e[91mhandle with care! original file will be shredded\e[0m"
  decrypt_filename=$(echo $1 | sed -r 's/.encrypt$//')
  if openssl aes-256-cbc -d -a -in $1 -out $decrypt_filename; then
    shred -f --zero $1
    rm -f $1
  else
    rm -f $decrypt_filename
  fi
}


t4(){
    SESSION=2

    tmux has-session -t $SESSION &> /dev/null

    if [ $? -eq 0 ]; then
        tmux attach -t $SESSION
        exit 0;
    fi
                                    
    tmux new-session -d -s $SESSION
    tmux split-window -h -t $SESSION:0
    tmux split-window -h -t $SESSION:0
    tmux split-window -h -t $SESSION:0
    tmux select-layout -t $SESSION "a490,119x39,0,0[120x19,0,0{59x19,0,0,11,60x19,60,0,12},120x19,0,20{59x19,0,20,13,60x19,60,20,18}]"
    tmux attach -t $SESSION
}

t2(){
    SESSION=2

    tmux has-session -t $SESSION &> /dev/null

    if [ $? -eq 0 ]; then
        tmux attach -t $SESSION
        exit 0;
    fi
                                    
    tmux new-session -d -s $SESSION
    
    if [ $1 == 'v'  ]
    then
        tmux split-window -v -t $SESSION:0
    else
        tmux split-window -h -t $SESSION:0
    fi

    tmux attach -t $SESSION
}

#pls+gib.sh from https://gist.github.com/AndrewBelt/89d1592cb39f544c7e1d

# Example session
#
# on receiver's terminal:
# $ pls > file.txt
#
# on sender's terminal:
# $ gib 192.168.1.2 < file.txt

PLSPORT=42069
PLSCERT=$HOME/.pls.pem

function pls() {
	if test ! -f $PLSCERT; then
		openssl req -x509 -nodes -days 365 -newkey rsa:1024 -out $PLSCERT -keyout $PLSCERT
	fi
	openssl s_server -accept $PLSPORT -naccept 1 -quiet -cert $PLSCERT -key $PLSCERT
}

function gib() {
	openssl s_client -connect $1:$PLSPORT -quiet -no_ign_eof
}

export VISUAL=nano
export LANG=de_DE.UTF-8

#LS_COLORS='di=36:ln=32:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43':
#export LS_COLORS

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
