emerge-webrsync
emerge --update --deep --with-bdeps=y --newuse --quiet @world
emerge --depclean
revdep-rebuild
