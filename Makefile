#Makefile to build pidstat commands for android (arch-arm64)
SRC_DIR = $(shell pwd)
COMPILE = ${SRC_DIR}/tools/aarch64-linux-android-4.9/bin
CC = ${COMPILE}/aarch64-linux-android-gcc
AR = ${COMPILE}/aarch64-linux-android-ar
NDK_SYSROOT=${SRC_DIR}/tools/ndk
CFLAGS = -g -O2 -Wall -Wstrict-prototypes -pipe -O2 
CFLAGS += --sysroot=${NDK_SYSROOT}
CFLAGS += -pie -fPIE
ALL: pidstat mpstat iostat
commom.o: common.c version.h common.h ioconf.h sysconfig.h
	$(CC) -o $@ -c $(CFLAGS) $<
ioconf.o: ioconf.c ioconf.h common.h sysconfig.h
	$(CC) -o $@ -c $(CFLAGS) $<
rd_stats_light.o: rd_stats.c common.h rd_stats.h ioconf.h sysconfig.h
	$(CC) -o $@ -c $(CFLAGS) $<
count_light.o: count.c common.h rd_stats.h
	$(CC) -o $@ -c $(CFLAGS) $<
libsyscom.a: common.o ioconf.o
	$(AR) rvs $@ $?
librdstats_light.a: rd_stats_light.o count_light.o
	$(AR) rvs $@ $? 
pidstat.o: pidstat.c pidstat.h version.h common.h rd_stats.h count.h
	$(CC) -o $@ -c $(CFLAGS) $<
mpstat.o: mpstat.c mpstat.h version.h common.h rd_stats.h count.h
	$(CC) -o $@ -c $(CFLAGS) $<
iostat.o: iostat.c iostat.h version.h common.h ioconf.h sysconfig.h rd_stats.h count.h
	$(CC) -o $@ -c $(CFLAGS) $<
pidstat: pidstat.o librdstats_light.a libsyscom.a
	$(CC) pidstat.o libsyscom.a librdstats_light.a -o $@ $(CFLAGS)
mpstat: mpstat.o librdstats_light.a libsyscom.a
	$(CC) mpstat.o libsyscom.a librdstats_light.a -o $@ $(CFLAGS)
iostat: iostat.o librdstats_light.a libsyscom.a
	$(CC) iostat.o libsyscom.a librdstats_light.a -o $@ $(CFLAGS)
.PHONY: clean
clean:
	rm -f *.o *.a pidstat mpstat iostat
