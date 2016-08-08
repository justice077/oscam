#!/bin/sh
plat=i686-pc-linux
plat_dir=build_i686Linux

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

cmake  -DCS_CONFDIR=/var/etc --clean-first -DWEBIF=1 $svnroot    #用cmake命令对源码进行交叉编译
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
