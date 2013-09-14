export DEBIAN_FRONTEND=noninteractive

# debian/ubuntu packages to install for installation from source
sudo apt-get -q -y install build-essential autoconf libtool mono-gmcs libglib2.0-dev libpango1.0-dev libatk1.0-dev libgtk2.0-dev libglade2-dev libart-2.0-dev libgnomevfs2-dev libgnome2-dev libgnomecanvas2-dev libgnomeui-dev libmono-addins-cil-dev libmono-addins-gui-cil-dev wget unzip

XS_VERSION=4.1.10
XS_TAG=monodevelop-4.1.10
MONO_VERSION=3.2.3
MONO_TAG=mono-3.2.3
GTK_SHARP_TAG=gtk-sharp-2-12-branch
GNOME_SHARP_TAG=master
FSHARP_TAG=3.0.27
FSHARP_BINDING_VERSION=3.2.15
FSHARP_BINDING_MPACK_URL=http://addins.monodevelop.com/Stable/Mac/4.1.10/MonoDevelop.FSharpBinding-3.2.15.mpack
XSP_TAG=3.0

mkdir -p $HOME/xamarin/build/mono
mkdir -p $HOME/xamarin/build/monodevelop
mkdir -p $HOME/xamarin/mono
mkdir -p $HOME/xamarin/monodevelop

# set up file to include for parallel environment
SOURCE_FILE=$HOME/xamarin/use-xs-mono
echo "#!/bin/bash" > $SOURCE_FILE
echo "MONO_PREFIX=\$HOME/xamarin/mono/current" >> $SOURCE_FILE
echo "GNOME_PREFIX=/usr" >> $SOURCE_FILE
echo "export DYLD_LIBRARY_FALLBACK_PATH=\$MONO_PREFIX/lib:\$DYLD_LIBRARY_FALLBACK_PATH" >> $SOURCE_FILE
echo "export LD_LIBRARY_PATH=\$MONO_PREFIX/lib:\$LD_LIBRARY_PATH" >> $SOURCE_FILE
echo "export C_INCLUDE_PATH=\$MONO_PREFIX/include:\$GNOME_PREFIX/include" >> $SOURCE_FILE
echo "export ACLOCAL_PATH=\$MONO_PREFIX/share/aclocal" >> $SOURCE_FILE
echo "export PKG_CONFIG_PATH=\$MONO_PREFIX/lib/pkgconfig:\$GNOME_PREFIX/lib/pkgconfig" >> $SOURCE_FILE
echo "export PATH=\$MONO_PREFIX/bin:\$PATH" >> $SOURCE_FILE
echo "alias xs='nohup \$HOME/xamarin/monodevelop/current/bin/monodevelop > /dev/null 2>&1 &'" >> $SOURCE_FILE

# checkout and build mono if the latest is not installed
if [ ! -d "$HOME/xamarin/mono/${MONO_VERSION}" ]; then
	rm -Rf $HOME/xamarin/build/mono/${MONO_VERSION}
	mkdir -p $HOME/xamarin/build/mono/${MONO_VERSION}
	cd $HOME/xamarin/build/mono/${MONO_VERSION}
	git clone --progress  https://github.com/mono/mono.git
	cd $HOME/xamarin/build/mono/${MONO_VERSION}/mono
	git checkout $MONO_TAG
	sed -i 's@git://github@https://github@' .gitmodules
	./autogen.sh --prefix=$HOME/xamarin/mono/${MONO_VERSION}
	make && make install

	# link current mono
	rm -f $HOME/xamarin/mono/current
	ln -s $HOME/xamarin/mono/${MONO_VERSION} $HOME/xamarin/mono/current
	source $SOURCE_FILE

	# checkout and build gtk-sharp
	cd $HOME/xamarin/build/mono/${MONO_VERSION}
	git clone --progress https://github.com/mono/gtk-sharp.git
	cd gtk-sharp
	git checkout $GTK_SHARP_TAG
	./bootstrap-2.12 --prefix=$HOME/xamarin/mono/${MONO_VERSION}
	make && make install

	# checkout and build gnome-sharp
	cd $HOME/xamarin/build/mono/${MONO_VERSION}
	git clone --progress https://github.com/mono/gnome-sharp.git
	cd gnome-sharp
	git checkout $GNOME_SHARP_TAG 
	./bootstrap-2.24 --prefix=$HOME/xamarin/mono/${MONO_VERSION}
	make && make install

	# checkout and build xsp4
	cd $HOME/xamarin/build/mono/${MONO_VERSION}
	git clone --progress https://github.com/mono/xsp.git
	cd xsp
	git checkout $XSP_TAG
	./autogen.sh --prefix=$HOME/xamarin/mono/${MONO_VERSION}
	make && make install

	# checkout and build fsharp
	cd $HOME/xamarin/build/mono/${MONO_VERSION}
	git clone --progress https://github.com/fsharp/fsharp.git
	cd fsharp
	git checkout $FSHARP_TAG 
	./autogen.sh --prefix=$HOME/xamarin/mono/${MONO_VERSION}
	make && make install
else
	echo "Mono ${MONO_VERSION} is already installed."
fi

# checkout and build monodevelop if the latest is not installed
if [ ! -d "$HOME/xamarin/monodevelop/${XS_VERSION}" ]; then
	source $SOURCE_FILE
	rm -Rf $HOME/xamarin/build/monodevelop/${XS_VERSION}
	mkdir -p $HOME/xamarin/build/monodevelop/${XS_VERSION}
	cd $HOME/xamarin/build/monodevelop/${XS_VERSION}
	git clone --progress https://github.com/mono/monodevelop.git
	cd $HOME/xamarin/build/monodevelop/${XS_VERSION}/monodevelop
	git checkout $XS_TAG
	sed -i 's@git://github@https://github@' .gitmodules
	DEFAULT_PROFILE=$HOME/xamarin/build/monodevelop/${XS_VERSION}/monodevelop/profiles/default
	echo "main" > $DEFAULT_PROFILE
	echo "extras/MonoDevelop.Database" >> $DEFAULT_PROFILE
	./configure --prefix=$HOME/xamarin/monodevelop/${XS_VERSION}
	make && make install

	# Install FSharp binding
	mkdir -p $HOME/.local/share/MonoDevelop-4.0/LocalInstall/Addins
	FS_BINDING_DIR=$HOME/.local/share/MonoDevelop-4.0/LocalInstall/Addins/MonoDevelop.FSharpBinding-${FSHARP_BINDING_VERSION}
	rm -Rf $HOME/.local/share/MonoDevelop-4.0/LocalInstall/Addins/MonoDevelop.FSharpBinding*
	mkdir $FS_BINDING_DIR
	cd $FS_BINDING_DIR		
	wget $FSHARP_BINDING_MPACK_URL
	unzip MonoDevelop.FSharpBinding*.mpack
	rm MonoDevelop.FSharpBinding*.mpack

	# link current monodevelop
	rm -f $HOME/xamarin/monodevelop/current
	ln -s $HOME/xamarin/monodevelop/${XS_VERSION} $HOME/xamarin/monodevelop/current
else
	echo "Monodevelop ${XS_VERSION} is already installed."
fi

# Add source entry to .bashrc if it doesn't exist
if [ `grep use-xs-mono $HOME/.bashrc | wc -l` -eq 0 ]; then
	echo "source \$HOME/xamarin/use-xs-mono" >> ~/.bashrc
fi
