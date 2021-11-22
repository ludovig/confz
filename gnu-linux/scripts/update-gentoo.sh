emerge-webrsync
layman -S
emerge --update --deep --with-bdeps=y --newuse --quiet-build --keep-going @world
emerge --depclean
revdep-rebuild
