#!/bin/sh
plat=cygwin
plat_dir=build_cygwin
TOOLCHAIN=i686-pc-cygwin

curdir=`pwd`
builddir=`dirname $0`

if [ "$builddir" = "." ]; then
	cd ..
	svnroot=`pwd`
else
	cd `dirname $builddir`
	svnroot=`pwd`
fi
[ -d $svnroot/build ] || mkdir -p $svnroot/build
rm -rf $svnroot/build/*
TOOLCHAINROOT=$(dirname $svnroot)/toolchains
##################################################################
cd $svnroot/build
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

cp $svnroot/build/oscam.exe $svnroot/${plat_dir}/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

rm -rf $svnroot/build/*
cd $curdir
