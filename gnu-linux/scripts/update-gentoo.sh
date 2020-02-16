emerge-webrsync
emerge --update --deep --with-bdeps=y --newuse --quiet --keep-going @world
emerge --depclean
revdep-rebuild
