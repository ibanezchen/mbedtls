if [ -z "$SOC" ]; then
	echo "set SOC variable"
	return
fi
export CC=arm-none-eabi-gcc
export AR=arm-none-eabi-ar
export RL=arm-none-eabi-ar

export PREFIX=${PREFIX:-"`pwd`/../prefix/arm-none-eabi"}
export DESTDIR=$PREFIX
source $PREFIX/bin/soc-${SOC}.sh
export COPTS=${COPTS:-"-march=armv7-a -mthumb"}
export MOPTS="${COPTS} -fno-builtin -fno-common -ffunction-sections -fdata-sections"

export CFLAGS="${MOPTS} -O2 -g \
${SOC_INC} \
-I${PREFIX}/include \
-D__socklen_t_defined \
-Dselect=lwip_select \
"
export LDFLAGS="${MOPTS} -g -nostartfiles -nodefaultlibs -L${PREFIX}/lib -L${PREFIX}/bin/${SOC} -Tram.ld "
export LDFLAGS="${LDFLAGS} -Wl,--start-group -lhcos -lc -lgcc ${SOC_LIB} -Wl,--end-group"
