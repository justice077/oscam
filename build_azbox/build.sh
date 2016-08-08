#!/bin/sh

plat=azbox
plat_dir=build_azbox
rm -f oscam oscam-$plat-svn*.tar.gz
PATH=../../toolchains/mipsel-unknown-linux-gnu/bin:$PATH \
cmake -DCMAKE_TOOLCHAIN_FILE=../toolchains/toolchain-mips-azbox.cmake --clean-first -DWEBIF=1 ..    #用cmake命令对源码进行交叉编译
make

[ -d image/PLUGINS/OpenXCAS/oscamCAS ] || mkdir -p image/PLUGINS/OpenXCAS/oscamCAS
cp oscam image/PLUGINS/OpenXCAS/oscamCAS/

curdir=`pwd`
builddir=`dirname $0`
[ "$builddir" = "." ] && svnroot=".."
[ "$builddir" = "." ] || svnroot=`dirname $builddir`
cd $svnroot/
svninfo=$(git svn info 2>/dev/null)
if [ "$svninfo" != "" ]; then
	svnver=_svn`echo $svninfo | sed -n "5p"| sed -e "s/ //g" | cut -f2 -d:`
fi
cd ${plat_dir}/image
tar czf ../oscam-${plat}${svnver}-nx111-`date +%Y%m%d`.tar.gz *
cd ../ 
rm -rf CMake* *.a Makefile cscrypt csctapi *.cmake config.* 
rm -rf minilzo utils algo image/var/bin/oscam
cd $curdir
