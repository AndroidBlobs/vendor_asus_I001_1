#!/vendor/bin/sh

declare -i retry

type=`getprop sys.station.pd_fwupdate`
updateon=`getprop sys.station.updatepdon`

echo "[PD_HID] PD FW update" > /dev/kmsg

if [ "$type" == "0" ]; then
	echo "[PD_HID] No need update PD FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	FW_PATH="/vendor/asusfw/station/IT5213.bin"
fi

if [ "$updateon" != "1" ]; then
	echo "[PD_HID] PD update trun off" > /dev/kmsg
	setprop sys.station.pd_fwupdate 0
	exit
fi

lsusb > /dev/kmsg

while [ "$(lsusb | grep -E "048d:5212|048d:52db")" == "" -a "$retry" -lt 3 ]
do
	retry=$(($retry+1))

	if [ "$retry" -eq 3 ]; then
		echo "[PD_HID] can't find pdhid device" > /dev/kmsg
		setprop sys.station.pd_fwupdate 2
		exit
	fi

	sleep 1
done

echo "[PD_HID] Start PD FW update : $FW_PATH" > /dev/kmsg

/vendor/bin/pd_update /vendor/asusfw/station/IT5213.bin > /dev/kmsg

if [ "$?" != "1" ]; then
	echo "[PD_HID] PD FW update fail" > /dev/kmsg
	setprop sys.station.pd_fwupdate 2
else
	echo "[PD_HID] PD FW update OK" > /dev/kmsg
	setprop sys.station.pd_fwupdate 0
fi

sleep 2

st_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`
if [ "$st_pdfw" == "ffff" ]; then
	st_pdfw=""
fi

setprop sys.station.pd_fwver $st_pdfw

setprop sys.asus.accy.fw_status2 000000

#echo 1 > /sys/class/ec_i2c/dongle/device/set_prota_cc
