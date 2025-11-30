#!/usr/bin/env bash
set -eou pipefail

INSTALL_PATH=$HOME/.apt-aside

cd $(dirname $0)

mkdir $INSTALL_PATH

echo Cloning debootstrap...
git clone --depth=1 https://salsa.debian.org/installer-team/debootstrap.git /tmp/debootstrap &>/dev/null

echo Running debootstrap...
DEBOOTSTRAP_DIR=/tmp/debootstrap fakechroot fakeroot /tmp/debootstrap/debootstrap --variant=minbase --include=fakeroot,fakechroot testing $INSTALL_PATH/debian &>/dev/null

echo Removing debootstrap...
rm -rf /tmp/debootstrap

echo Installing apt-aside...
mkdir $INSTALL_PATH/bin
mkdir $INSTALL_PATH/root_bin

ln -s $INSTALL_PATH/chroot_wrapper.sh $INSTALL_PATH/root_bin/dpkg
ln -s $INSTALL_PATH/chroot_wrapper.sh $INSTALL_PATH/root_bin/apt-get
ln -s $INSTALL_PATH/chroot_wrapper.sh $INSTALL_PATH/root_bin/bash

cp ./wrapper.sh $INSTALL_PATH/
cp ./chroot_wrapper.sh $INSTALL_PATH/
cp ./make_symlinks.sh $INSTALL_PATH/
cp ./uninstall.sh $INSTALL_PATH/

echo "$INSTALL_PATH/root_bin/apt-get \$@" > $INSTALL_PATH/bin/apt-get-aside
echo "$INSTALL_PATH/root_bin/bash \$@" > $INSTALL_PATH/bin/apt-aside-bash

ln -s $INSTALL_PATH/make_symlinks.sh $INSTALL_PATH/bin/apt-aside-expose
ln -s $INSTALL_PATH/bin/apt-get-aside $INSTALL_PATH/bin/apt-aside-get

chmod +x $INSTALL_PATH/bin/*

echo "Add \"$INSTALL_PATH\"/bin to your path:"
echo "  # in .bashrc, .zshrc, or your shell's equivalent"
echo "  export PATH=\$PATH:$INSTALL_PATH/bin"
echo Done!
