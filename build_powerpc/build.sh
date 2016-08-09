#!/bin/sh
plat=powerpc
plat_dir=build_powerpc
TOOLCHAIN=powerpc-tuxbox-linux-gnu

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
   cmake  -DCMAKE_TOOLCHAIN_FILE=$svnroot/toolchains/toolchain-powerpc-tuxbox.cmake\
	  --clean-first -DWEBIF=1 \
	  -DOPTIONAL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_INCLUDE_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/include\
	  -DOPENSSL_LIBRARIES=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN/lib\
	  -DOPENSSL_ROOT_DIR=$TOOLCHAINROOT/$TOOLCHAIN/$TOOLCHAIN\
	  -DWITH_SSL=1\
	  $svnroot

make

[ -d $svnroot/${plat_dir}/image/var/bin ] || mkdir -p $svnroot/${plat_dir}/image/var/bin
cp $svnroot/build/oscam $svnroot/${plat_dir}/image/var/bin/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/${plat_dir}
rm -f oscam oscam-$plat-svn*.tar.gz

cd $svnroot/${plat_dir}/image
tar czf ../oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *

cd $svnroot/${plat_dir}
rm -rf $svnroot/build/*
cd $curdir
