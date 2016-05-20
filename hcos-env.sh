#!/bin/bash

if [ -z "$SOC" ]; then
	echo "set SOC variable, e.g. linkit, ameba"
	return
fi
PREFIX=${PREFIX:-../prefix/arm-none-eabi}
source $PREFIX/bin/cfg-${SOC}.sh
eval cfg_${SOC}

export CC=arm-none-eabi-gcc
export AR=arm-none-eabi-ar
export RL=arm-none-eabi-ar

export DESTDIR=$PREFIX
echo DESTDIR=$DESTDIR

export CFLAGS="${COPTS} -fno-builtin -fno-common -ffunction-sections -fdata-sections -O2 -g \
${SOC_INC} \
-I${PREFIX}/include \
-D__socklen_t_defined \
-DMBEDTLS_LWIP \
-DMBEDTLS_FS_IO_DISABLE \
-DMBEDTLS_PLATFORM_MEMORY \
"
echo CFLAGS=$CFLAGS

export LDFLAGS="${MOPTS} -g -nostartfiles -nodefaultlibs -L${PREFIX}/lib -L${PREFIX}/bin/${SOC} -Tram.ld "
export LDFLAGS="${LDFLAGS} -Wl,--start-group -lhcos -lc -lgcc ${SOC_LIB} -Wl,--end-group"
echo LDFLAGS=$LDFLAGS
