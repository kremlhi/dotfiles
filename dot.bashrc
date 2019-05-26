# -*- mode: sh -*-
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
     *i*) ;;
     *) return ;;
esac

if [ -z "$BASHRC" -a -f "$HOME/.profile" ]; then
    BASHRC=1
    . "$HOME/.profile"
fi

case "$TERM" in
    xterm*|rxvt*)
        if command -v awd >/dev/null 2>&1; then
            PROMPT_COMMAND='9 awd'
        fi
        ;;
    *) ;;
esac
