#!/usr/bin/env bash
set -eou pipefail

INSTALL_PATH=$HOME/.apt-aside

print_green () {
	echo -e "\e[0;32m$1\e[0m"
}
print_red () {
	echo -e "\e[0;31m$1\e[0m"
}
clean_up_debootstrap () {
	rm -rf /tmp/debootstrap
}
remove_apt_aside () {
	print_red "Error detected. Uninstalling partial apt-aside installation."
	rm -rf ~/.apt-aside
}
cancel_installation () {
	print_red "Cancelling apt-aside installation."
	rm -rf ~/.apt-aside
	exit 0
}
add_chroot_wrapper () {
	ln -s $INSTALL_PATH/chroot_wrapper.sh $INSTALL_PATH/root_bin/$1
}
add_sys_cmd () {
	USER_NAME=$1
	CMD_NAME=$2
	add_chroot_wrapper $CMD_NAME
	echo "$INSTALL_PATH/root_bin/$CMD_NAME" > $INSTALL_PATH/bin/$USER_NAME
}
run_debootstrap () {
	print_green "Cloning debootstrap..."
	git clone --depth=1 https://salsa.debian.org/installer-team/debootstrap.git /tmp/debootstrap
	trap clean_up_debootstrap EXIT
	print_green "Running debootstrap..."
	PATH=$PATH:/sbin DEBOOTSTRAP_DIR=/tmp/debootstrap fakeroot /tmp/debootstrap/debootstrap --foreign --variant=minbase --exclude=passwd --include=fakeroot testing $INSTALL_PATH/debian
	proot -0 -r $INSTALL_PATH/debian -w / bash -c "DEBOOTSTRAP_DIR=/debootstrap/ PATH=/sbin:/usr/bin /debootstrap/debootstrap --second-stage"
}
command_exists () {
	if hash $1 &>/dev/null; then
		return 0
	else
		return 1
	fi
}

if [[ -d $INSTALL_PATH ]]; then
	print_red "apt-aside installation already exists."
	exit 1
fi
if [[ -a $INSTALL_PATH ]]; then
	print_red "a file already exists where apt-aside wants to install itself"
	exit 1
fi

trap remove_apt_aside ERR
trap cancel_installation SIGINT

if ! command_exists proot; then
	print_red "PRoot is not installed; it is a dependency of apt-aside."
	exit 1
fi
if ! command_exists git; then
	print_red "Git is not installed; it is required to install apt-aside."
	exit 1
fi
if ! command_exists fakeroot; then
	print_red "fakeroot is not installed; it is required to install apt-aside."
	exit 1
fi

cd $(dirname $0)

mkdir $INSTALL_PATH

run_debootstrap

print_green "Installing apt-aside..."
mkdir $INSTALL_PATH/bin
mkdir $INSTALL_PATH/root_bin

add_sys_cmd apt-get-aside apt-get
add_sys_cmd apt-aside-bash bash
add_sys_cmd apt-aside apt
# dependency of apt-aside-expose
add_chroot_wrapper dpkg

cp ./wrapper.sh $INSTALL_PATH/
cp ./chroot_wrapper.sh $INSTALL_PATH/
cp ./make_symlinks.sh $INSTALL_PATH/
cp ./uninstall.sh $INSTALL_PATH/

ln -s $INSTALL_PATH/make_symlinks.sh $INSTALL_PATH/bin/apt-aside-expose
ln -s $INSTALL_PATH/bin/apt-get-aside $INSTALL_PATH/bin/apt-aside-get

chmod +x $INSTALL_PATH/bin/*

print_green "Done!\n"

print_green "Add \"$INSTALL_PATH/bin\" to your path:"
echo "  # in .bashrc, .zshrc, or your shell's equivalent"
echo "  export PATH=$INSTALL_PATH/bin:\$PATH"
