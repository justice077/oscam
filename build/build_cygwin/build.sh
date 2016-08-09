#!/bin/sh
plat=cygwin
plat_dir=build_cygwin
TOOLCHAIN=i686-pc-cygwin

curdir=`pwd`
builddir=$(cd $(dirname $0);pwd)
svnroot=`pwd`

[ -d $svnroot/build/.tmp ] || mkdir -p $svnroot/build/.tmp
rm -rf $svnroot/build/.tmp/*

TOOLCHAINROOT=$(dirname $svnroot)/toolchains
##################################################################
cd $svnroot/build/.tmp
PATH=$TOOLCHAINROOT/$TOOLCHAIN/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$svnroot/toolchains/toolchain-i386-cygwin.cmake\
	  -DCMAKE_LEGACY_CYGWIN_WIN32=1\
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/\
	  -DWITH_SSL=1\
	  --clean-first\
	  -DWEBIF=1 $svnroot
make

cp $svnroot/build/.tmp/oscam.exe $svnroot/build/${plat_dir}/image/
##################################################################
svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/build/${plat_dir}/image
if [ $# -ge 1 -a "$1" = "-debug" ]; then
	compile_time=$(date +%Y%m%d%H%M)D
else
	compile_time=$(date +%Y%m%d)
fi
tar czf $svnroot/build/oscam-${plat}-r${svnver}-nx111-${compile_time}.tar.gz *

rm -rf $svnroot/build/.tmp/*
cd $curdir
