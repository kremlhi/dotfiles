#!/bin/sh

set -eu

umask 077
wd=$(dirname "$0")

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
            ln -fs "../$dotfiles/$j" "$dst"
        done
        continue
    fi
    ln -fs "$dotfiles/$i" "$dst"
done
