#Makefile to build pidstat commands for android (arch-arm64)
SRC_DIR = $(shell pwd)
COMPILE = ${SRC_DIR}/tools/aarch64-linux-android-4.9/bin
CC = ${COMPILE}/aarch64-linux-android-gcc
AR = ${COMPILE}/aarch64-linux-android-ar
NDK_SYSROOT=${SRC_DIR}/tools/ndk
CFLAGS = -g -O2 -Wall -Wstrict-prototypes -pipe -O2 
CFLAGS += --sysroot=${NDK_SYSROOT}
CFLAGS += -pie -fPIE
pidstat: pidstat.o librdstats_light.a libsyscom.a
	@$(CC) pidstat.o libsyscom.a librdstats_light.a -o $@ $(CFLAGS)
commom.o: common.c version.h common.h ioconf.h sysconfig.h
	@$(CC) -o $@ -c $(CFLAGS) $<
ioconf.o: ioconf.c ioconf.h common.h sysconfig.h
	@$(CC) -o $@ -c $(CFLAGS) $<
rd_stats_light.o: rd_stats.c common.h rd_stats.h ioconf.h sysconfig.h
	@$(CC) -o $@ -c $(CFLAGS) $<
count_light.o: count.c common.h rd_stats.h
	@$(CC) -o $@ -c $(CFLAGS) $<
libsyscom.a: common.o ioconf.o
	@$(AR) rvs $@ $?
librdstats_light.a: rd_stats_light.o count_light.o
	@$(AR) rvs $@ $? 

pidstat.o: pidstat.c pidstat.h version.h common.h rd_stats.h count.h
	@$(CC) -o $@ -c $(CFLAGS) $<
.PHONY: clean
clean:
	rm *.o *.a pidstat
