#!/bin/sh
CFLAGS="-qlanglvl=extc1x -qascii -D_OPEN_THREADS=3 -D_UNIX03_SOURCE=1 -DNSIG=39 -D_AE_BIMODAL=1 -D_XOPEN_SOURCE_EXTENDED -D_ALL_SOURCE -D_ENHANCED_ASCII_EXT=0xFFFFFFFF -D_OPEN_SYS_FILE_EXT=1 -D_OPEN_SYS_SOCK_IPV6 -D_XOPEN_SOURCE=600 -D_XOPEN_SOURCE_EXTENDED -qfloat=ieee"

c99 -o./otest ${CFLAGS} otest.c
if [ $? -eq 0 ]; then
	./otest /tmp/hw.txt
fi

# Test that untagged files are read in as EBCDIC
input="/usr/include/errno.h"
chtag -r "${input}"

c99 -o./itest ${CFLAGS} itest.c
if [ $? -eq 0 ]; then
	./itest "${input}"
fi
