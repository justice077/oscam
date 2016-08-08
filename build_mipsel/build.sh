#!/bin/sh
plat=mipsel
plat_dir=build_mipsel

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

##################################################################
cd $svnroot/build
PATH=../../toolchains/mipsel-unknown-linux-gnu/bin:$PATH \
   cmake  -DCMAKE_TOOLCHAIN_FILE=../toolchains/toolchain-mips-tuxbox.cmake --clean-first -DWEBIF=1 $svnroot    #用cmake命令对源码进行交叉编译
make

[ -d $svnroot/${plat_dir}/image/usr/bin ] || mkdir -p $svnroot/${plat_dir}/image/usr/bin
cp $svnroot/build/oscam $svnroot/${plat_dir}/image/usr/bin/

##################################################################

svnver=`$svnroot/config.sh --oscam-revision`

cd $svnroot/${plat_dir}
rm -f oscam oscam-$plat-svn*.tar.gz

cd $svnroot/${plat_dir}/image
tar czf ../oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *

cd $svnroot/${plat_dir}
rm -rf $svnroot/build/*
cd $curdir
