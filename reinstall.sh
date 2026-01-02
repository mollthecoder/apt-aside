#!/usr/bin/env bash
# shellcheck disable=SC2016
set -eou pipefail

INSTALL_PATH="$HOME/.apt-aside"

INSTALLED_PACKAGES=$("$INSTALL_PATH/root_bin/dpkg-query" -f '"${binary:Package}" ' -W)

EXPOSED_PACKAGES=$(cat "$INSTALL_PATH/exposed-packages")

rm -rf "$INSTALL_PATH"
./install.sh
DEBIAN_FRONTEND=noninteractive xargs apt-aside-get install -y <<< "$INSTALLED_PACKAGES"

for package in $EXPOSED_PACKAGES; do
	if [[ ! $package ]]; then
		continue
	fi
	apt-aside-expose "$package"
done

echo "Reinstall complete!"
