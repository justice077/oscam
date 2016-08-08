#!/bin/sh

plat=powerpc
plat_dir=build_powerpc
rm -f oscam oscam-nx111  oscam-$plat-svn*.tar.gz
PATH=../../toolchains/powerpc-tuxbox-linux-gnu/bin:$PATH \
cmake -DCMAKE_TOOLCHAIN_FILE=../toolchains/toolchain-powerpc-tuxbox.cmake -DWEBIF=1 ..    #用cmake命令对源码进行交叉编译
make

[ -d image/var/bin ] || mkdir -p image/var/bin
cp oscam image/var/bin/

curdir=`pwd`
builddir=`dirname $0`
[ "$builddir" = "." ] && svnroot=".."
[ "$builddir" = "." ] || svnroot=`dirname $builddir`
cd $svnroot/
svnver=`./config.sh --oscam-revision`
cd ${plat_dir}/image
tar czf ../oscam-${plat}-r${svnver}-nx111-`date +%Y%m%d`.tar.gz *
cd ../ 
rm -rf CMake* *.a Makefile cscrypt csctapi *.cmake config.* 
rm -rf minilzo utils algo image/var/bin/oscam
cd $curdir
