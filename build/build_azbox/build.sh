#!/bin/sh
plat=azbox
plat_dir=build_azbox
TOOLCHAIN=mipsel-unknown-linux-gnu

curdir=`pwd`
builddir=`dirname $0`

if [ "$builddir" = "." ]; then
	cd ../..
	svnroot=`pwd`
else
	cd $(dirname $(dirname $builddir))
	svnroot=`pwd`
fi
[ -d $svnroot/build/.tmp ] || mkdir -p $svnroot/build/.tmp
rm -rf $svnroot/build/.tmp/*
TOOLCHAINROOT=$(dirname $svnroot)/toolchains
##################################################################
cd $svnroot/build/.tmp
PATH=$TOOLCHAINROOT/mipsel-unknown-linux-gnu/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=$svnroot/toolchains/toolchain-mips-azbox.cmake \
	  --clean-first -DWEBIF=1 \
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/sys-root/usr/\
	  -DWITH_SSL=1\
	  $svnroot
make

[ -d $svnroot/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS ] || mkdir -p $svnroot/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS
cp $svnroot/build/.tmp/oscam $svnroot/build/${plat_dir}/image/PLUGINS/OpenXCAS/oscamCAS/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/build/${plat_dir}
rm -f oscam oscam-$plat-svn*.tar.gz

cd $svnroot/build/${plat_dir}/image
tar czf $svnroot/build/oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *

rm -rf $svnroot/build/.tmp/*
cd $curdir
