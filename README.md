# ubuntu-xam-tools
Scripts to build what is effectively the equivalent of the delightful and beautiful Xamarin Studio
on Ubuntu.  It is designed to be continuously updated and applied as new versions of MonoDevelop
and Mono are released.  Check the release immediately below to see if a new version is available
for update.  Should work on Ubuntu 13.04.

Current Versions:
-----------------
  * Mono 3.2.3
  * MonoDevelop 4.1.10

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
Running MonoDevelop:
--------------------
The script will add a line to .bashrc which sources the mono parallel environment and an alias
to run monodevelop.  Open a new command line shell and type the following command to run MonoDevelop:
```bash
xs
```
