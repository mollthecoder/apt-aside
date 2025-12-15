export PATH=/usr/bin:/sbin:/usr/sbin
DEBOOTSTRAP_DIR=/debootstrap/ /debootstrap/debootstrap --second-stage

echo "Finalizing apt-aside environment..."

locale-gen
update-locale
apt modernize-sources -y

