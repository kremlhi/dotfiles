#!/bin/sh
# usage: install.sh [-n]

set -eu

umask 077
wd=$(dirname "$0")
ln=ln
# dry run
if [ $# -eq 1 ] && [ "x$1" = 'x-n' ]; then
	ln='echo ln'
fi

cd "$wd"
dotfiles=${PWD#$HOME/}
case "$dotfiles" in /*)
    echo "error: $PWD not under $HOME" >&2
    exit 1 ;;
esac
for i in dot.*; do
    dst=$HOME/${i#dot}
    if [ -d "$i" ]; then
        mkdir -p "$dst"
        for j in "$i"/*; do
            ln -sfv "../$dotfiles/$j" "$dst"
        done
        continue
    fi
    ln -sfv "$dotfiles/$i" "$dst"
done
