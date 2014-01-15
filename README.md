# ubuntu-xam-tools
Scripts to build what is effectively the equivalent of the delightful and beautiful Xamarin Studio
on Ubuntu.  It is designed to be continuously updated and applied as new versions of MonoDevelop
and Mono are released.  Check the release immediately below to see if a new version is available
for update.  Should work on Ubuntu 12.04 up to 13.04 (13.10 has an issue with the tabs not displaying file names)

Current Versions:
-----------------
  * Mono 3.2.5
  * MonoDevelop 4.3.1

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
