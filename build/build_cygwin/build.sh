#!/bin/sh
plat=cygwin
plat_dir=build_cygwin
TOOLCHAIN=i686-pc-cygwin

curdir=`pwd`
builddir=$(cd $(dirname $0);pwd)
ROOT=`pwd`

[ -d $ROOT/build/.tmp ] || mkdir -p $ROOT/build/.tmp
rm -rf $ROOT/build/.tmp/*

TOOLCHAINROOT=$(dirname $ROOT)/toolchains
##################################################################
cd $ROOT/build/.tmp
PATH=$TOOLCHAINROOT/$TOOLCHAIN/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$ROOT/toolchains/toolchain-i386-cygwin.cmake\
	  -DCMAKE_LEGACY_CYGWIN_WIN32=1\
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/\
	  -DWITH_SSL=1\
	  --clean-first\
	  -DWEBIF=1 $ROOT
make

cp $ROOT/build/.tmp/oscam.exe $ROOT/build/${plat_dir}/image/
##################################################################
svnver=`$ROOT/config.sh --oscam-revision`

cd $ROOT/build/${plat_dir}/image
if [ $# -ge 1 -a "$1" = "-debug" ]; then
	compile_time=$(date +%Y%m%d%H%M)D
else
	compile_time=$(date +%Y%m%d)
fi
tar czf $ROOT/build/oscam-${plat}-r${svnver}-nx111-${compile_time}.tar.gz *

rm -rf $ROOT/build/.tmp/*
cd $curdir
