# Set network cards
if [[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]]; then
	sed -i 's/ONBOOT=.*/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i 's/NM_CONTROLLED=.*/NM_CONTROLLED=no/' /etc/sysconfig/network-scripts/ifcfg-eth0
	if [[ ! -f /etc/sysconfig/network-scripts/ifcfg-eth1 ]]; then
		if grep -q eth1 /etc/udev/rules.d/70-persistent-net.rules; then 
			address=`grep eth1 /etc/udev/rules.d/70-persistent-net.rules | sed 's/.*ATTR{address}=="\([^"]*\).*/\1/'`
			cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth1
			sed -i 's/DEVICE=.*/DEVICE=eth1/' /etc/sysconfig/network-scripts/ifcfg-eth1
			sed -i 's/HWADDR=.*/HWADDR='${address}'/' /etc/sysconfig/network-scripts/ifcfg-eth1
			sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth1
			rm /etc/udev/rules.d/70-persistent-net.rules
			ifup eth1
		fi
	fi
fi

# Install what could be installed with yum
yum install -y git wget
yum install -y mlocate yum-utils xterm rxvt-unicode
yum groupinstall -y 'Development tools' 'Desktop Platform Development' 'X Window System' 'Fonts'
yum install -y ImageMagick startup-notification startup-notification-devel readline readline-devel libXdmcp-devel pam-devel kernel-devel libev-devel

# Set local toolbox
[[ ! -d Downloads ]] && mkdir Downloads
cd ./Downloads

# Install external repositories
if [[ ! -f rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ]]; then
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
	rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
fi
if [[ ! -f epel-release-6-8.noarch.rpm ]]; then
	wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm
fi

# Install guest additions
if dmidecode | grep -q VirtualBox; then
	if ! lsmod  | grep -q vbox; then
		yum -y install dkms
		if [[ ! -f VBoxGuestAdditions_4.2.6.iso ]]; then
			wget http://download.virtualbox.org/virtualbox/4.2.6/VBoxGuestAdditions_4.2.6.iso
		fi
		mount -o loop -t iso9660 VBoxGuestAdditions_4.2.6.iso /mnt/
		cd /mnt/
		./VBoxLinuxAdditions.run --noexec --target ~/TMP/
		cd ~/TMP/
		mkdir ../TMP2
		tar jxvf VBoxGuestAdditions-amd64.tar.bz2 -C ../TMP2/
		cd ../TMP2/src/vboxguest-4.2.6/vboxvideo/
		cat > el6.patch << EOL
--- vboxvideo_drm.c.ori 2013-03-01 12:11:52.146639050 +0100
+++ vboxvideo_drm.c     2013-03-01 12:18:57.231061446 +0100
@@ -70,6 +70,9 @@
 #   if RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(6,3)
 #    define DRM_RHEL63
 #   endif
+#   if RHEL_RELEASE_CODE >= RHEL_RELEASE_VERSION(6,4)
+#    define DRM_RHEL64
+#   endif
 #  endif
 # endif
 
@@ -106,7 +109,7 @@
 {
     /* .driver_features = DRIVER_USE_MTRR, */
     .load = vboxvideo_driver_load,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 6, 0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 6, 0) && !defined(DRM_RHEL64)
     .reclaim_buffers = drm_core_reclaim_buffers,
 #endif
     /* As of Linux 2.6.37, always the internal functions are used. */
EOL

		patch -p0 < el6.patch
		cd ~/TMP2/
		tar jcvf ../TMP/VBoxGuestAdditions-amd64.tar.bz2 *
		cd ~/TMP
		./install.sh
		cd ~/Downloads
	fi
fi

# Disable selinux
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# Retrieve sources
[[ ! -f Python-2.7.4.tar.bz2 ]] && wget http://www.python.org/ftp/python/2.7.4/Python-2.7.4.tar.bz2
[[ ! -f libffi-3.0.13-includedir-1.patch ]] && wget http://www.linuxfromscratch.org/patches/blfs/svn/libffi-3.0.13-includedir-1.patch
[[ ! -f libffi-3.0.13.tar.gz ]] && wget ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
[[ ! -f glib-2.36.1.tar.xz ]] && wget http://ftp.gnome.org/pub/GNOME/sources/glib/2.36/glib-2.36.1.tar.xz
[[ ! -f cmake-2.8.10.2.tar.gz ]] && wget http://www.cmake.org/files/v2.8/cmake-2.8.10.2.tar.gz
[[ ! -f gobject-introspection-1.36.0.tar.xz ]] && wget http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.36/gobject-introspection-1.36.0.tar.xz
[[ ! -f xcb-util-0.3.9.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-util-0.3.9.tar.gz
[[ ! -f libxcb-1.9.tar.gz ]] && wget http://xcb.freedesktop.org/dist/libxcb-1.9.tar.gz
[[ ! -f libpthread-stubs-0.3.tar.gz ]] && wget http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.gz
[[ ! -f xcb-proto-1.8.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-proto-1.8.tar.gz
[[ ! -f xcb-util-keysyms-0.3.9.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.3.9.tar.gz
[[ ! -f xcb-util-image-0.3.9.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-util-image-0.3.9.tar.gz
[[ ! -f xcb-util-wm-0.3.9.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-util-wm-0.3.9.tar.gz
[[ ! -f xcb-util-renderutil-0.3.8.tar.gz ]] && wget http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.8.tar.gz
[[ ! -f libxdg-basedir-1.2.0.tar.gz ]] && wget http://nevill.ch/libxdg-basedir/downloads/libxdg-basedir-1.2.0.tar.gz
[[ ! -f cairo-1.12.14.tar.xz ]] && wget http://cairographics.org/releases/cairo-1.12.14.tar.xz
[[ ! -f lua-5.1.5.tar.gz ]] && wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
[[ ! -d lgi ]] && git clone https://github.com/pavouk/lgi.git
[[ ! -f harfbuzz-0.9.16.tar.bz2 ]] && wget http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.16.tar.bz2
[[ ! -f pango-1.32.5.tar.xz ]] && wget http://ftp.gnome.org/pub/gnome/sources/pango/1.32/pango-1.32.5.tar.xz
[[ ! -d awesome ]] && git clone git://git.naquadah.org/awesome.git
[[ ! -f lightdm-1.6.0.tar.xz ]] && wget https://launchpad.net/lightdm/1.6/1.6.0/+download/lightdm-1.6.0.tar.xz
[[ ! -f xplanet-1.3.0.tar.gz ]] && wget http://downloads.sourceforge.net/project/xplanet/xplanet/1.3.0/xplanet-1.3.0.tar.gz?use_mirror=freefr 
[[ ! -f confuse-2.7.tar.gz ]] && wget http://savannah.nongnu.org/download/confuse/confuse-2.7.tar.gz 
[[ ! -f unagi-0.3.3.tar.gz ]] && wget http://projects.mini-dweeb.org/attachments/download/111/unagi-0.3.3.tar.gz

# Start building stuff
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig/"

# python
if [[ ! -d Python-2.7.4 ]]; then
	tar xvf Python-2.7.4.tar.bz2
	cd Python-2.7.4
	./configure && make && make install || exit 1
	cd ..
fi

# cmake
if [[ ! -d cmake-2.8.10.2 ]]; then
	tar xvf cmake-2.8.10.2.tar.gz
	cd cmake-2.8.10.2
	./bootstrap && make && make install || exit 1
	cd ..
fi

# libffi
if [[ ! -d libffi-3.0.13 ]]; then
	tar xvf libffi-3.0.13.tar.gz
	cd libffi-3.0.13
	patch -Np1 -i ../libffi-3.0.13-includedir-1.patch
	./configure --disable-static && make && make install || exit 1
	ln -s /usr/local/lib64/libffi.so.6.0.1 /usr/local/lib/libffi.so.6
	ln -s /usr/local/lib64/libffi.so.6.0.1 /usr/local/lib/libffi.so
	cd ..
fi

# glib
if [[ ! -d glib-2.36.1 ]]; then
	tar xvf glib-2.36.1.tar.xz
	cd glib-2.36.1
	./configure && make && make install || exit 1
	cd ..
fi

# gobject-introspection
if [[ ! -d gobject-introspection-1.36.0 ]]; then
	tar xvf gobject-introspection-1.36.0.tar.xz
	cd gobject-introspection-1.36.0
	./configure && make && make install || exit 1
	cd ..
fi

# xcb
if [[ ! -d xcb-proto-1.8 ]]; then
	tar xvf xcb-proto-1.8.tar.gz
	cd xcb-proto-1.8
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d xcb-util-0.3.9 ]]; then
	tar xvf xcb-util-0.3.9.tar.gz
	cd xcb-util-0.3.9
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d xcb-util-keysyms-0.3.9 ]]; then
	tar xvf xcb-util-keysyms-0.3.9.tar.gz
	cd xcb-util-keysyms-0.3.9
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d xcb-util-image-0.3.9 ]]; then
	tar xvf xcb-util-image-0.3.9.tar.gz
	cd xcb-util-image-0.3.9
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d xcb-util-wm-0.3.9 ]]; then
	tar xvf xcb-util-wm-0.3.9.tar.gz
	cd xcb-util-wm-0.3.9
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d xcb-util-renderutil-0.3.8 ]]; then
	tar xvf xcb-util-renderutil-0.3.8.tar.gz
	cd xcb-util-renderutil-0.3.8
	./configure && make && make install || exit 1
	cd ..
fi


if [[ ! -d libxcb-1.9 ]]; then
	tar xvf libxcb-1.9.tar.gz
	cd libxcb-1.9
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d libxdg-basedir-1.2.0 ]]; then
	tar xvf libxdg-basedir-1.2.0.tar.gz
	cd libxdg-basedir-1.2.0
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d libpthread-stubs-0.3 ]]; then
	tar xvf libpthread-stubs-0.3.tar.gz
	cd libpthread-stubs-0.3
	./configure && make && make install || exit 1
	cd ..
fi

if [[ ! -d lua-5.1.5 ]]; then
	tar xvf lua-5.1.5.tar.gz
        cd lua-5.1.5
	make linux && make install || exit 1
	cd ..
fi

# cairo
if [[ ! -d cairo-1.12.14 ]]; then
	tar xvf cairo-1.12.14.tar.xz
	cd cairo-1.12.14
	./configure --enable-xcb && make && make install || exit 1
	cd ..
fi

# lightdm
if [[ ! -d lightdm-1.6.0 ]]; then
	tar xvf lightdm-1.6.0.tar.xz
	cd lightdm-1.6.0
	./configure && make && make install || exit 1
	cd ..
fi

# lgi
if [[ ! -d /usr/local/lib/lua/5.1/lgi ]]; then
	cd lgi
	make
	make install PREFIX= DESTDIR=/usr
	mkdir usr/lib64/lua/5.1/lgi/
	cp /usr/lib/lua/5.1/lgi/corelgilua51.so /usr/lib64/lua/5.1/lgi/
	cd ..
fi

if [[ ! -d harfbuzz-0.9.16 ]]; then
	tar xvf harfbuzz-0.9.16.tar.bz2
	cd harfbuzz-0.9.16
	./configure && make && make install || exit 1
	ldconfig
	cd ..
fi

if [[ ! -d pango-1.32.5 ]]; then
	tar xvf pango-1.32.5.tar.xz
	cd pango-1.32.5
	./configure && make && make install || exit 1
	cd ..
fi

# and finally, awesome
if [[ ! -f /usr/local/share/doc/awesome/README ]]; then
	export AWESOME_IGNORE_LGI=1
	cd awesome
	make
	make install
fi

if [[ ! -f /etc/ld.so.conf.d/local-x86_64.conf ]]; then
	echo '/usr/local/lib' > /etc/ld.so.conf.d/local-x86_64.conf
	echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-x86_64.conf
	ldconfig
fi

# xplanet
if [[ ! -d xplanet-1.3.0 ]]; then
	tar xvf xplanet-1.3.0.tar.gz
	cd xplanet-1.3.0
	./configure && make && make install || exit 1
	cd ..
fi

# libconfuse
if [[ ! -d confuse-2.7 ]]; then
	tar xvf confuse-2.7.tar.gz
	cd confuse-2.7
	./configure && make && make install || exit 1
	cd ..
fi

# unagi
if [[ ! -d unagi-0.3.3 ]]; then
	tar xvf unagi-0.3.3.tar.gz
	cd unagi-0.3.3
	./configure && make && make install || exit 1
	cd ..
fi
