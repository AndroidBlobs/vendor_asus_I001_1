#!/vendor/bin/sh

insmod /vendor/lib/modules/ec_i2c_interface.ko
echo 13 > /sys/class/ec_hid/dongle/device/sync_state

uart_state=`getprop persist.asus.audbg_station`
echo "station uart state : $uart_state" > /dev/kmsg
if [ "$uart_state" == "0" ]; then
	echo "turn off station uart." > /dev/kmsg
	echo 0 > /sys/class/ec_i2c/dongle/device/uart
elif [ "$uart_state" == "1" ]; then
	echo "turn on station uart." > /dev/kmsg
	echo 1 > /sys/class/ec_i2c/dongle/device/uart
fi
