#!/bin/sh
plat=powerpc
plat_dir=build_powerpc
TOOLCHAIN=powerpc-tuxbox-linux-gnu

curdir=`pwd`
builddir=$(cd $(dirname $0);pwd)
svnroot=`pwd`

[ -d $svnroot/build/.tmp ] || mkdir -p $svnroot/build/.tmp
rm -rf $svnroot/build/.tmp/*

TOOLCHAINROOT=$(dirname $svnroot)/toolchains

##################################################################
cd $svnroot/build/.tmp
PATH=$TOOLCHAINROOT/$TOOLCHAIN/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$svnroot/toolchains/toolchain-powerpc-tuxbox.cmake\
	  --clean-first -DWEBIF=1 \
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN\
	  -DWITH_SSL=1\
	  $svnroot

make

[ -d $svnroot/build/${plat_dir}/image/var/bin ] || mkdir -p $svnroot/build/${plat_dir}/image/var/bin
cp $svnroot/build/.tmp/oscam $svnroot/build/${plat_dir}/image/var/bin/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/build/${plat_dir}/image
tar czf $svnroot/build/oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *

rm -rf $svnroot/build/.tmp/*
cd $curdir
