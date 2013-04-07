if uname -a | grep -q DARWIN; then
  exec twm
fi

awesome & wmpid=$!

# keyboard
xset r rate 300 50
xkbcomp -w 0 -R/usr/share/X11/xkb -I/$HOME/.xkb/ $HOME/.xkb/jekalitf $DISPLAY
xkbset m ma 60 20 25 30 500

# X config
xrdb -merge $HOME/.Xresources

# programs automatically launched
urxvtd -q -f -o
xplanet -radius 1 -range 100 -base_magnitude 11 -starmap ~/.xplanet/tycho-2 -transparency -num_times 1 -separation moon:1 -config $HOME/.xplanet/config/star -glare 0 -output $HOME/.xplanet/images/star_background.png -geometry 1900x1200 -wait 1800&
xplanet -separation moon:0,017 -radius 25 -range 8750 -transparency -north orbit -background $HOME/.xplanet/images/star_background.png&
urxvtc
gvim

[[ -d $HOME/atelier/clavier/xkeyvents ]] && $HOME/atelier/clavier/xkeyvents/logkeys.py

# local
if [[ -r ~/.xprofile_local ]]; then
  . ~/.xprofile_local
fi

# run all system xinitrc shell scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/* ; do
        if [ -x "$i" ]; then
	    . "$i"
        fi
    done
fi

firefox

wait $wmpid
