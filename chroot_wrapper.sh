#!/usr/bin/env bash
BIN_NAME=$(basename "$0")
BIN_PATH="/usr/bin/$BIN_NAME"


command_exists () {
	if hash "$1" &>/dev/null; then
		return 0
	else
		return 1
	fi
}
use_bwrap () {
	if (( ${APT_ASIDE_FORCE_BWRAP:-0} )); then
		echo "apt-aside: Forcing bubblewrap usage"
		return 0
	fi
	if (( ${APT_ASIDE_FORCE_PROOT:-0} )); then
		return 1
	fi
	command_exists bwrap
}
use_proot () {
	if (( ${APT_ASIDE_FORCE_PROOT:-0} )); then
		echo "apt-aside: Forcing PRoot usage"
		return 0
	fi
	if (( ${APT_ASIDE_FORCE_BWRAP:-0} )); then
		return 1
	fi
	command_exists proot
}

if use_bwrap; then
	bwrap --uid 0 --gid 0 --unshare-all --share-net --hostname apt-aside --dev-bind "$HOME/.apt-aside/debian/" / --proc /proc --setenv FAKEROOTDONTTRYCHOWN 1 --die-with-parent --new-session -- /usr/bin/fakeroot-sysv /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/libfakeroot --argv0 "$BIN_NAME" "$BIN_PATH" "$@"
elif use_proot; then
	proot -r "$HOME/.apt-aside/debian" -b /proc -w / -0 /usr/bin/fakeroot-sysv /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/libfakeroot --argv0 "$BIN_NAME" "$BIN_PATH" "$@"
else
	echo "Error: Neither bwrap nor proot are installed. Please install one or the other to perform system operations in apt-aside."
fi
