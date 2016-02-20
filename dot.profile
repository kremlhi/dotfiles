# -*- mode: sh -*-

uniqpath(){
    printf %s "$1" | awk 'BEGIN{RS=ORS=":"}; {if(!d[$0]++)print}' | sed 's/:$//'
}

SYS=$(uname -s | tr '[:upper:]' '[:lower:]'); export SYS
SYSREL=$(uname -r); export SYSREL
ARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/x86_64/amd64/'); export ARCH
HOMESW=$HOME/sw/$SYS-$ARCH; export HOMESW

INFERNO=/opt/inferno; export INFERNO
SYSHOST=$(uname -s|sed 's/Darwin/MacOSX/'); export SYSHOST
OBJTYPE=$(uname -m|sed 's/.*86.*/386/'); export OBJTYPE
ACIDLIB=$INFERNO/lib/acid; export ACIDLIB
EMU="-r$INFERNO -g1100x700"; export EMU

BREW=/opt/brew; [ -d "$BREW" ] || BREW=/usr/local; export BREW
CABALBIN=$(sed -n 's/^extra-prog-path: //p' ~/.cabal/config 2>/dev/null)
GOPATH=$HOME/src/go; export GOPATH
PLAN9=/opt/p9p; export PLAN9

PATH=$(uniqpath "$HOME/bin:$HOMESW/bin:$BREW/bin:$CABALBIN:/opt/local/bin:/usr/local/bin:$HOME/repos/tailf-doc/bin:$PATH:$PLAN9/bin:$GOPATH/bin:$INFERNO/$SYSHOST/$OBJTYPE/bin")
export PATH

[ ! -d "$BREW/opt/openssl" ] || USE_SSL_DIR=$BREW/opt/openssl export USE_SSL_DIR
tailf=$HOME/repos/tailf; export tailf
[ ! -e "$tailf/env.sh" ] || . "$tailf/env.sh"

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1
export DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS_VERIFY

MANPATH=$(uniqpath "$HOMESW/man:$BREW/lib/erlang/man:$BREW/share/man:/usr/X11R6/man:/usr/local/man:/usr/local/share/man:/opt/man:/usr/share/man:/usr/man:/Library/Developer/CommandLineTools/usr/share/man:$MANPATH")
export MANPATH

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

LANG=${LANG:-en_US.UTF-8}
LC_CTYPE=${LC_CTYPE:-"$LANG"}
export LANG LC_CTYPE

alias ls='ls -F'
alias e=$EDITOR
