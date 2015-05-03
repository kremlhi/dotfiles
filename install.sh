#!/bin/sh

set -eu

umask 077
wd=$(dirname "$0")

cd "$wd"
dotfiles=${PWD#$HOME/}
for i in dot.*; do
    dst=../${i#dot}
    if [ -d "$i" ]; then
        mkdir -p "$dst"
        for j in "$i"/*; do
            ln -fs "../$dotfiles/$j" "$dst"
        done
        continue
    fi
    ln -fs "$dotfiles/$i" "$dst"
done
