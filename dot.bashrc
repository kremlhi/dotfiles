# -*- mode: sh -*-
# ~/.bashrc: executed by bash(1) for non-login shells.

BREW=/brew
CABALBIN=$(sed -n 's/^extra-prog-path: //p' ~/.cabal/config 2>/dev/null)
PATH=$HOME/bin:$HOMESW/bin:$BREW/bin:$CABALBIN:\
/Applications/VLC.app/Contents/MacOS:$PATH
PATH=$(echo "$PATH" | \
awk 'BEGIN{OFS=FS=":"}; {for(i=1;i<=NF;i++)if(d[$i]++)$i=""; print}' | \
sed -e 's/::*/:/g' -e 's/:$//')
export PATH

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

PS1='\h\$ '
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;\$PWD/-\h\a\]$PS1" ;;
    *) ;;
esac

alias ls='ls -F'
