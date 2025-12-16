# Python isn't a language I use. I apologize for what follows.
import platform
import site
import os


(major, minor, _) = platform.python_version_tuple()
dist_path = f"~/.apt-aside/debian/usr/local/lib/python{major}.{minor}/dist-packages"
site.addsitedir(os.path.expanduser(dist_path))
site.addsitedir(os.path.expanduser("~/.apt-aside/debian/usr/lib/python3/dist-packages"))

