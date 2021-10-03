#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

XDG_CURRENT_DESKTOP=gnome
xset b off
xrandr --setprovideroutputsource modesetting NVIDIA-0
autorandr -c --skip-options crtc mobile

setxkbmap -option caps:swapescape
exec i3
