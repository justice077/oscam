#!/bin/sh
plat=cygwin
plat_dir=build_cygwin
TOOLCHAIN=i686-pc-cygwin

#TOOLCHAINROOT=/work/dreambox/toolchains

##############################################################
curdir=`pwd`
builddir=`cd $(dirname $0);pwd`

if [ "${OSCAM_SRC}" != "" -a -f ${OSCAM_SRC}/oscam.c ]; then
	ROOT=${OSCAM_SRC}
elif [ -f $(dirname $(dirname $builddir))/oscam.c ]; then
	ROOT=$(dirname $(dirname $builddir))
else
	echo "Not found oscam source directory! Please set OSCAM_SRC environment value..."
	cd $curdir
	exit
fi

# fix config.sh for subverison changed to git
if [ -f $ROOT/config.sh ]; then
	cp $ROOT/config.sh $ROOT/config.sh.orig
	sed -e "s/^[[:space:]]*(svnversion .*/\
		revision=\`(svnversion -n . 2>\/dev\/null || printf 0) | sed \'s\/.*:\/\/; s\/[^0-9]*$\/\/; s\/^$\/0\/'\`\n\
\n\
		if [ \"\$revision\" = \"\" -o \"\$revision\" = \"0\" ]; then\n\
			git log  | grep git-svn-id | sed -n 1p | cut -d@ -f2 | cut -d' ' -f1\n\
		else\n\
			echo \$revision\n\
		fi\n\
/" -i $ROOT/config.sh

fi

[ -d $ROOT/build/.tmp ] || mkdir -p $ROOT/build/.tmp
rm -rf $ROOT/build/.tmp/*

[ "$TOOLCHAINROOT" = "" ] && TOOLCHAINROOT=$(dirname $ROOT)/toolchains
if [ ! -f $TOOLCHAINROOT/$TOOLCHAIN/bin/$TOOLCHAIN-gcc ]; then
	echo "Not found $TOOLCHAIN-gcc..."
	exit -1
fi
##################################################################
cd $ROOT/build/.tmp
cp $ROOT/config.h $ROOT/config.h.orig

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
[ -f $ROOT/config.h.orig ] && mv $ROOT/config.h.orig $ROOT/config.h

cp $ROOT/build/.tmp/oscam.exe ${builddir}/image/
##################################################################
svnver=`$ROOT/config.sh --oscam-revision`
[ -f $ROOT/config.sh.orig ] && mv $ROOT/config.sh.orig $ROOT/config.sh


cd ${builddir}/image
if [ $# -ge 1 -a "$1" = "-debug" ]; then
	compile_time=$(date +%Y%m%d%H%M)D
else
	compile_time=$(date +%Y%m%d)
fi
tar czf $(dirname $builddir)/oscam-${plat}-r${svnver}-nx111-${compile_time}.tar.gz *

rm -rf $ROOT/build/.tmp/*
cd $curdir
