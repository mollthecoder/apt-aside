[default]
all: shellcheck install_nasm_bwrap install_nasm_proot test_locale


shellcheck:
	shellcheck *.sh

uninstall:
	./uninstall.sh

install: uninstall
	./install.sh

install_nasm_bwrap $APT_ASIDE_FORCE_BWRAP="1": install
	apt-aside update -y
	apt-aside upgrade -y
	apt-aside install nasm -y
	apt-aside remove nasm -y

install_nasm_proot $APT_ASIDE_FORCE_PROOT="1": install
	apt-aside update -y
	apt-aside upgrade -y
	apt-aside install nasm -y
	apt-aside remove nasm -y

test_locale: install
	#!/usr/bin/env bash
	SYSTEM_LOCALE="$(locale)"
	APT_ASIDE_LOCALE="$(apt-aside-bash -c "locale")"
	if [[ "$SYSTEM_LOCALE" != "$APT_ASIDE_LOCALE" ]]; then
		exit 1
	fi
