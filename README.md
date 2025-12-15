# apt-aside
apt-aside is a series of shell scripts intended to enable the installation of Debian Testing packages on a Debian Stable system without compromising the stability of the system. It achieves this by creating a second Debian installation in your home directory. It avoids the overhead of running an entire container or VM, like that of distrobox.

Important: apt-aside is NOT a security sandbox. Do NOT use it to run untrusted programs.

## What Doesn't Work
The following packages will not work:
- Daemons
- Packages that have postinstall scripts that require real root (note: scripts that work via fakeroot will work fine)
- Packages that depend on a kernel that is newer than that of Debian Stable
- Packages that depend on daemons newer than that of your current system 

## What Will Work
Development tools, programming languages, most GUI apps, and more.

## Alternatives
Each of these alternatives have significantly larger communities backing them and are likely more polished and reliable. Before using apt-aside, consider these alternatives.
- [JuNest](https://github.com/fsquillace/junest) - Similar concept but with Arch Linux instead of Debian Testing.
- [Debian Backports](https://backports.debian.org/) - Ports of packages from Debian Testing to Debian Stable. Much smaller package selection but the most reliable solution if your package exists here.
- [Flatpak](https://flatpak.org/) - Purpose-built for GUI apps and with security in mind. Almost always has the latest package versions. Often integrated with graphical package managers.
- [distrobox](https://distrobox.it/) - Use any Linux distro inside of your terminal. Uses a more heavyweight container system. 
- [Snaps](https://snapcraft.io/) - Cross-distro package bundles.

## Dependencies

When installing apt-aside for the first time, the following packages must be installed on your system:
- git
- fakeroot
- [PRoot](https://proot-me.github.io/)

After apt-aside has been installed, at least one of the following must be installed on your system:
- [PRoot](https://proot-me.github.io/)
- [Bubblewrap](https://github.com/containers/bubblewrap/) (bwrap)

If both PRoot and Bubblewrap are installed at the same time, apt-aside will use Bubblewrap by default.

apt-aside also relies on debootstrap during installation, but will clone it into /tmp for you, and delete it when the installation is complete. This is necessary because versions of debootstrap that are newer than what is provided by Debian Stable are needed. 

apt-aside only works on x86-64/amd64 systems.

## Installation
```sh
./install.sh
```
After the installation is complete, follow the on-screen instructions to add apt-aside to your PATH.

## Usage

Example:
```sh
apt-aside update
apt-aside upgrade
apt-aside install nasm
apt-aside-expose nasm
nasm --version
```

### apt-aside
The apt binary of apt-aside's Debian installation. See the usage of `apt`.

### apt-aside-bash
Launches a fakeroot and prooted bash into apt-aside's Debian Testing installation. 

### apt-aside-expose
Usage: apt-aside-expose [package name]

Adds all of the binaries of a package that is installed in apt-aside's Debian installation to your PATH.

### apt-aside-unexpose
Usage: apt-aside-unexpose [package name]

Un-exposes a previously exposed package.

### apt-get-aside
Alias: apt-aside-get

The apt-get binary of apt-aside's Debian installation. See the usage of `apt-get`.

None of these commands require root.

## Environment Variables
When running any of the above commands, you may set the environment variables `APT_ASIDE_FORCE_BWRAP` or `APT_ASIDE_FORCE_PROOT` to 1 to force apt-aside to rely on either dependency if you have both installed on your system. If only one is installed, apt-aside will auto-detect which one to use for you.

## Uninstallation
Run the following command to uninstall apt-aside:

```sh
rm -rf ~/.apt-aside
```

Any programs you installed using apt-aside will also be removed.

## License
apt-aside is licensed under the MIT license. See license.txt.
