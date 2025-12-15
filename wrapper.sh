#!/usr/bin/env bash
INSTALL_PATH="$HOME/.apt-aside"

BIN_NAME="$(basename "$0")"
BIN_PATH="$INSTALL_PATH/debian/usr/bin/$BIN_NAME"
"$INSTALL_PATH/debian/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2" --argv0 "$BIN_NAME" --library-path "$INSTALL_PATH/debian/lib/x86_64-linux-gnu/:$INSTALL_PATH/debian/usr/lib/x86_64-linux-gnu" "$BIN_PATH" "$@"
