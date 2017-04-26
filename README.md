# pidstat
pidstat for android6.0 (aarch64)

generate pidstat step:

1.git clone https://github.com/zhenggaobing/pidstat.git

2.cd pidstat

3.make

4.we will get pidstat mpstat iostat bin file

add pidstat mpstat iostat tool for Android 6.0

adb remount
adb push pidstat /system/bin
adb push mpstat  /system/bin
adb push iostat  /system/bin
adb reboot
