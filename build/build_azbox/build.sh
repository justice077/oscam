#!/bin/sh
plat=azbox
plat_dir=build_azbox
TOOLCHAIN=mipsel-unknown-linux-gnu

curdir=`pwd`
builddir=`dirname $0`

if [ "$builddir" = "." ]; then
	cd ../..
	ROOT=`pwd`
else
	cd $(dirname $(dirname $builddir))
	ROOT=`pwd`
fi
[ -d $ROOT/build/.tmp ] || mkdir -p $ROOT/build/.tmp
rm -rf $ROOT/build/.tmp/*
TOOLCHAINROOT=$(dirname $ROOT)/toolchains
##################################################################
cd $ROOT/build/.tmp
PATH=$TOOLCHAINROOT/mipsel-unknown-linux-gnu/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$ROOT/toolchains/toolchain-mips-azbox.cmake \
	  --clean-first -DWEBIF=1 \
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/\
	  -DWITH_SSL=1\
	  $ROOT
make

[ -d $ROOT/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS ] || mkdir -p $ROOT/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS
cp $ROOT/build/.tmp/oscam $ROOT/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS/

##################################################################

svnver=`$ROOT/config.sh --oscam-revision`

cd $ROOT/build/${plat_dir}
rm -f oscam oscam-$plat-svn*.tar.gz

cd $ROOT/build/${plat_dir}/image
if [ $# -ge 1 -a "$1" = "-debug" ]; then
	compile_time=$(date +%Y%m%d%H%M)D
else
	compile_time=$(date +%Y%m%d)
fi
tar czf $ROOT/build/oscam-${plat}-r${svnver}-nx111-${compile_time}.tar.gz *

rm -rf $ROOT/build/.tmp/*
cd $curdir
