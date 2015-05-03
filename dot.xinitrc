xsetroot -solid black
xrdb ~/.Xresources
setxkbmap -variant dvorak -layout us \
    -option 'altwin:swap_alt_win' \
    -option 'ctrl:nocaps' \
    -option 'compose:rwin'
autocutsel &
autocutsel -s PRIMARY &

[ -n "$SSH_AGENT_PID" ] || eval `ssh-agent`
ssh-add </dev/null

exec xmonad
exec xfce4-session
exec unity
exec xterm
