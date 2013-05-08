# ubuntu-xam-tools
Scripts to build what is effectively the equivalent of the delightful and beautiful Xamarin Studio
on Ubuntu.  It is designed to be continuously updated and applied as new versions of MonoDevelop
and Mono.

Current Versions:
-----------------
  * Mono 3.0.10
  * MonoDevelop 4.0.4

Usage initial installation:
---------------------------
```bash
git clone https://github.com/watertree/ubuntu-xam-tools.git
cd ubuntu-xam-tools
./update_xamarin_tools.sh
```
Getting updates:
----------------
```bash
git pull --rebase
./update_xamarin_tools.sh
```
