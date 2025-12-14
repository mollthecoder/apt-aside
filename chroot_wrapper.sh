#!/usr/bin/env bash
BIN_NAME=$(basename $0)
BIN_PATH=/usr/bin/$BIN_NAME
#bwrap --uid 0 --gid 0 --unshare-all --share-net --hostname apt-aside --dev-bind $HOME/.apt-aside/debian/ / --die-with-parent -- /usr/bin/fakeroot-sysv /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/libfakeroot --argv0 $BIN_NAME $BIN_PATH $@
proot -r $HOME/.apt-aside/debian -w / -0 /usr/bin/fakeroot-sysv /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/libfakeroot --argv0 $BIN_NAME $BIN_PATH $@
