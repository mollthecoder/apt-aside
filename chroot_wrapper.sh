#!/usr/bin/env bash
BIN_NAME=$(basename $0)
BIN_PATH=/usr/bin/$BIN_NAME
fakechroot fakeroot /sbin/chroot $HOME/.apt-aside/debian/ /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/fakechroot:/usr/lib/x86_64-linux-gnu/libfakeroot --argv0 $BIN_NAME $BIN_PATH $@
