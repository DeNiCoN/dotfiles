#
# ~/.bash_profile
#
export PATH="${PATH}:/home/denicon/.local/bin:/home/denicon/.cargo/bin:/home/denicon/.emacs.d/bin:/home/denicon/.config/rofi/bin"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
