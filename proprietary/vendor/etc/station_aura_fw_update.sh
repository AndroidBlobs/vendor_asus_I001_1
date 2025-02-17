#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`

if [ "$type" != "2" ]; then
	echo "[AURA_POGO] In accy $type, skip update." > /dev/kmsg
	setprop sys.station.aura_fwupdate 0
	exit
fi
echo 1 > /sys/class/leds/aura_station/update_state
echo "[AURA_POGO] Enable VDD" > /dev/kmsg
echo 1 > /sys/class/leds/aura_station/VDD
sleep 0.5

FW_PATH="/vendor/asusfw/aura_sync/6K5xxx_Yoda.Bin"
fw_ver=`cat /sys/class/leds/aura_station/fw_ver`
aura_fw=`getprop sys.asusfw.station.aura_fwver`

echo "[AURA_POGO] aura_fw : ${aura_fw}" > /dev/kmsg
echo "[AURA_POGO] fw_ver : ${fw_ver}" > /dev/kmsg

if [ "${fw_ver}" != "${aura_fw}" ]; then
    echo "[AURA_POGO] Strat ENE 6k582 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/aura_station/fw_update
else
	echo "[AURA_POGO] No need update" > /dev/kmsg
fi
sleep 1
fw_ver=`cat /sys/class/leds/aura_station/fw_ver`
if [ "${fw_ver}" != "${aura_fw}" ]; then
	echo "[AURA_POGO] ENE 6k582 FW update fail" > /dev/kmsg
	setprop sys.station.aura_fwupdate 2

else
	setprop sys.station.aura_fwver $fw_ver
	setprop sys.station.aura_fwupdate 0
fi
echo 0 > /sys/class/leds/aura_station/update_state
#start DongleFWCheck
