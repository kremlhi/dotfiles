# -*- mode: sh -*-

# Bibliotek borde brännas då och då, eljes blir bagaget för stort att släpa på.
#set +o history
HISTFILE=''

uniqpath(){
    printf %s "$1" | awk -v RS=: -v ORS=: '/ /{next}; {if(!d[$0]++)print}' | \
        sed 's/:$//'
}

ENV=$HOME/.env; export ENV
BASH=no; export BASH
SYS=$(uname -s | tr '[:upper:]' '[:lower:]'); export SYS
SYSREL=$(uname -r); export SYSREL
ARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/x86_64/amd64/'); export ARCH
HOMESW=$HOME/sw/$SYS-$ARCH; export HOMESW

ACIDLIB=$INFERNO/lib/acid; export ACIDLIB
EMU="-r$INFERNO -g1100x700"; export EMU
INFERNO=/opt/inferno; export INFERNO
OBJTYPE=$(uname -m|sed 's/.*86.*/386/'); export OBJTYPE
SYSHOST=$(uname -s|sed 's/Darwin/MacOSX/'); export SYSHOST
PLAN9=$HOME/repos/p9p; export PLAN9

GOPATH=$HOME/src/go; export GOPATH
GOROOT=/usr/local/go; export GOROOT

POST_SALES_TOOLS=$HOME/repos/post-sales-tools
export POST_SALES_TOOLS

BREW=/opt/brew; [ -d "$BREW" ] || BREW=/usr/local; export BREW
CABALBIN=$(sed -n 's/^extra-prog-path: //p' $HOME/.cabal/config 2>/dev/null)

PATH=$(uniqpath "$HOME/bin:$HOMESW/bin:$BREW/bin:$CABALBIN:/opt/local/bin:/usr/local/bin:$HOME/repos/tailf-doc-tools/bin:/Applications/Emacs.app/Contents/MacOS/bin:$PATH:$PLAN9/bin:$GOPATH/bin:$INFERNO/$SYSHOST/$OBJTYPE/bin:$POST_SALES_TOOLS/bin:$POST_SALES_TOOLS/jira")
export PATH

[ ! -d "$BREW/opt/openssl" ] || USE_SSL_DIR=$BREW/opt/openssl export USE_SSL_DIR
tailf=$HOME/repos/tailf; export tailf

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1
export DOCKER_HOST DOCKER_CERT_PATH DOCKER_TLS_VERIFY

OTPROOT=$HOME/repos/tailf/otp
OTPMAN=$(ls -d $OTPROOT/lib/*/doc $OTPROOT/erts/doc 2>/dev/null | \
             awk 'BEGIN{ORS=":"}; {print}')

MANPATH=$(uniqpath "$HOMESW/man:$BREW/lib/erlang/man:$BREW/share/man:/usr/X11R6/man:/usr/local/man:/usr/local/share/man:/opt/man:/usr/share/man:/usr/man:/Library/Developer/CommandLineTools/usr/share/man:$OTPMAN:$MANPATH")
export MANPATH

ALTERNATIVE_EDITOR=ed; export ALTERNATIVE_EDITOR
EDITOR=emacsclient; export EDITOR

case "$SYS:$TERM" in
     *:dumb) PAGER=cat ;;
     Linux:*) PAGER=less ;;
     *) PAGER=more ;;
esac
LESS=-FemXLs
export PAGER LESS

PROMPT_COMMAND='test -z "$INSIDE_EMACS$LUX_SHELLNAME" && awd 2>/dev/null'
export PROMPT_COMMAND
PS1='\h\$ '; export PS1

LANG=${LANG:-en_US.UTF-8}
LC_CTYPE=${LC_CTYPE:-"$LANG"}
export LANG LC_CTYPE

alias ls='ls -F'
alias e=$EDITOR
