# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
     *i*) ;;
     *) return ;;
esac

SYS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed 's/i.86/386/')
EDITOR=emacsclient
case "$SYS:$TERM" in
     *:dumb) PAGER=cat ;;
     linux:*) PAGER=less ;;
     *) PAGER=more ;;
esac
LESS=-FemXLs
HOMESW=$HOME/sw
export EDITOR PAGER LESS HOMESW

[ ! -d "$HOME/bin" ] || PATH=$HOME/bin:$PATH
export PATH

PS1='\h\$ '
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\$PWD-\h\a\]$PS1" ;;
*) ;;
esac

alias ls='ls -F'
