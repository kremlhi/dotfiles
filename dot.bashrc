# -*- mode: sh -*-
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
     *i*) ;;
     *) return ;;
esac

if [ -z "$BASHRC" -a -f "$HOME/.profile" ]; then
    BASHRC=1; export BASHRC
    . "$HOME/.profile"
fi
