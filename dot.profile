# -*- mode: sh -*-

SYS=$(uname -s | tr '[:upper:]' '[:lower:]'); export SYS
ARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/x86_64/amd64/'); export ARCH
HOMESW=$HOME/sw/$SYS-$ARCH; export HOMESW

BREW=/brew; export BREW
CABALBIN=$(sed -n 's/^extra-prog-path: //p' ~/.cabal/config 2>/dev/null)
GOROOT=/usr/local/go; export GOROOT
PLAN9=/p9p; export PLAN9

PATH=$HOME/bin:$HOMESW/bin:$BREW/bin:$CABALBIN:\
$GOROOT/bin:/usr/local/bin:\
/Applications/VLC.app/Contents/MacOS:$PATH:$PLAN9/bin

PATH=$(echo "$PATH" | \
awk 'BEGIN{OFS=FS=":"}; {for(i=1;i<=NF;i++)if(d[$i]++)$i=""; print}' | \
sed -e 's/::*/:/g' -e 's/:$//')
export PATH

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1
export DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS_VERIFY

ALTERNATIVE_EDITOR=ed; export ALTERNATIVE_EDITOR
EDITOR=emacsclient; export EDITOR

case "$SYS:$TERM" in
     *:dumb) PAGER=cat ;;
     linux:*) PAGER=less ;;
     *) PAGER=more ;;
esac
LESS=-FemXLs
export PAGER LESS

PS1='\h\$ '
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\033]0;\$(echo \"\$PWD\" | sed 's:^/\$::')/-\h\007\]$PS1" ;;
    *) ;;
esac
export PS1

alias ls='ls -F'

