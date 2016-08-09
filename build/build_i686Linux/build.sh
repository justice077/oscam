#!/bin/sh
plat=i686_linux
plat_dir=build_i686Linux
TOOLCHAIN=i686-pc-linux-gnu

curdir=`pwd`
builddir=$(cd $(dirname $0);pwd)
svnroot=`pwd`

[ -d $svnroot/build/.tmp ] || mkdir -p $svnroot/build/.tmp
rm -rf $svnroot/build/.tmp/*

TOOLCHAINROOT=$(dirname $svnroot)/toolchains

##################################################################
cd $svnroot/build/.tmp
PATH=$TOOLCHAINROOT/$TOOLCHAIN/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$svnroot/toolchains/toolchain-i686-pc-linux.cmake\
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sysroot/usr/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sysroot/usr/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sysroot/usr/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sysroot/usr/\
	  -DWITH_SSL=1\
	  -DSTATIC_LIBUSB=1\
	  --clean-first\
	  -DWEBIF=1 $svnroot
make

[ -d $svnroot/build/${plat_dir}/image/usr/bin ] || mkdir -p $svnroot/build/${plat_dir}/image/usr/bin
cp $svnroot/build/.tmp/oscam $svnroot/build/${plat_dir}/image/usr/bin/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/build/${plat_dir}/image
tar czf $svnroot/build/oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *

rm -rf $svnroot/build/.tmp/*
cd $curdir
