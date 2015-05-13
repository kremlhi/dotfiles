# -*- mode: sh -*-

SYS=$(uname -s | tr '[:upper:]' '[:lower:]'); export SYS
ARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/x86_64/amd64/'); export ARCH
HOMESW=$HOME/sw/$SYS-$ARCH; export HOMESW

BREW=/brew; [ -d "$BREW" ] || BREW=/usr/local; export BREW
CABALBIN=$(sed -n 's/^extra-prog-path: //p' ~/.cabal/config 2>/dev/null)
GOROOT=/usr/local/go; export GOROOT
PLAN9=/p9p; export PLAN9

PATH=$HOME/bin:$HOMESW/bin:$BREW/bin:$CABALBIN:\
$GOROOT/bin:/usr/local/bin:$PATH:$PLAN9/bin

PATH=$(echo "$PATH" | \
awk 'BEGIN{OFS=FS=":"}; {for(i=1;i<=NF;i++)if(d[$i]++)$i=""; print}' | \
sed -e 's/::*/:/g' -e 's/:$//')
export PATH

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1
export DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS_VERIFY

MANPATH=$HOMESW/man:$BREW/lib/erlang/man:$BREW/share/man:/usr/local/man:\
/usr/share/man:$MANPATH; export MANPATH

ALTERNATIVE_EDITOR=ed; export ALTERNATIVE_EDITOR
EDITOR=emacsclient; export EDITOR

case "$SYS:$TERM" in
     *:dumb) PAGER=cat ;;
     linux:*) PAGER=less ;;
     *) PAGER=more ;;
esac
LESS=-FemXLs
export PAGER LESS

PS1='\h\$ '; export PS1

alias ls='ls -F'
alias e=$EDITOR
