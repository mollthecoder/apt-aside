# apt-aside
apt-aside is a series of shell scripts intended to enable the installation of Debian Testing packages on a Debian Stable system without compromising the stability of the system. It achieves this by creating a second Debian installation in your home directory. It avoids the overhead of running an entire container or VM, like that of distrobox.

## What Doesn't Work
The following packages will not work:
- Daemons
- Packages that have postinstall scripts that require real root (note: scripts that work via fakeroot will work fine)
- Packages that depend on a kernel that is newer than that of Debian Stable
- Packages that depend on daemons newer than that of your current system 

## What Will Work
Development tools, programming languages, most GUI apps, and more.

## Dependencies
apt-aside requires the following packages to already be installed on your system:
- fakeroot*
- fakechroot*
- bubblewrap (bwrap)
- git
- GNU coreutils
- bash (bash must be installed, but it is fine if it is not your main shell)

*Package is only necessary when installing apt-aside for the first time

apt-aside also relies on debootstrap during installation, but will clone it into /tmp for you, and delete it when the installation is complete.
apt-aside only works on x86-64 systems, aka amd64.

## Installation
```sh
./install.sh
```
After the installation is complete, follow the on-screen instructions to add apt-aside to your PATH.

## Usage

Example:
```sh
apt-get-aside update
apt-get-aside upgrade
apt-get-aside install nasm
apt-aside-expose nasm
nasm --version
```

### apt-aside-bash
Launches a fakeroot and fakechroot bash into apt-aside's Debian Testing installation. 

### apt-aside-expose
Usage: apt-aside-expose [package name]<br/>
Adds all of the binaries of a package that is installed in apt-aside's Debian installation to your PATH.

### apt-get-aside
Alias: apt-aside-get<br/>
The apt-get binary of apt-aside's Debian installation. See the usage of `apt-get`.

None of these commands require root.

## License
apt-aside is licensed under the MIT license. See license.txt.
