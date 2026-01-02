#!/usr/bin/env bash
set -eou pipefail

INSTALL_PATH=$HOME/.apt-aside

if [[ $# -lt 1 ]]; then
	echo "Too few arguments."
	echo "Usage: $0 [PACKAGE_NAME]"
	exit 1
fi
if [[ $# -gt 1 ]]; then
	echo "Too many arguments."
	echo "Usage: $0 [PACKAGE_NAME]"
	exit 1
fi

echo "$1" >> "$INSTALL_PATH/exposed-packages"

for file in $("$INSTALL_PATH/root_bin/dpkg-query" -L "$1"); do
	SOURCE_PATH="$INSTALL_PATH/debian$file"
	if [[ $SOURCE_PATH != $INSTALL_PATH/debian/usr/bin/* ]]; then
		continue
	fi
	if [[ -f $SOURCE_PATH && -x $SOURCE_PATH ]]; then
		ln -s "$INSTALL_PATH/wrapper.sh" "$INSTALL_PATH/bin/$(basename "$file")"
	fi
done
