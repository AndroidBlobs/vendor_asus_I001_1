#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
thermal_type=`getprop persist.asus.thermalfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`


function enable_mic(){
	echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
	cat /sys/class/hwmon/Inbox_Fan/device/PWM
	echo "[INBOX_FAN][AUTO]enable_mic after sys.asus.fan.mic changed" > /dev/kmsg
}

function disable_mic(){
	fan_type=`getprop persist.asus.userfan`
	if [ "$fan_type" == "auto" ]; then
		echo "thermal fan since sys.asus.fan.mic changed"
		if [ "$thermal_type" == "0" ]; then
			echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][AUTO]thermal_type 0: default 1 (low)" > /dev/kmsg
		elif [ "$thermal_type" == "1" ]; then
			echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][AUTO]thermal_type 1: low" > /dev/kmsg
		elif [ "$thermal_type" == "2" ]; then
			echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][AUTO]thermal_type 2: mediun" > /dev/kmsg
		elif [ "$thermal_type" == "3" ]; then
			echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][AUTO]thermal_type 3: high" > /dev/kmsg
		elif [ "$thermal_type" == "4" ]; then
			echo 4 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][AUTO]thermal_type 4 will be set 3 (high)" > /dev/kmsg
		fi
	else
			echo "[INBOX_FAN][AUTO]thermal fan will not  be set auto" > /dev/kmsg
	fi
}


if [ "$dongle_type" == "1" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
		cat /sys/class/hwmon/Inbox_Fan/device/PWM
		echo "[INBOX_FAN][AUTO]enable_mic mic_type=$mic_type" > /dev/kmsg
	else
		if [ "$fan_type" == "auto" ]; then
			echo "thermal fan"
			if [ "$thermal_type" == "0" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 0: default 1 (low)" > /dev/kmsg
			elif [ "$thermal_type" == "1" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 1: low" > /dev/kmsg
			elif [ "$thermal_type" == "2" ]; then
				echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 2: mediun" > /dev/kmsg
			elif [ "$thermal_type" == "3" ]; then
				echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 3: high" > /dev/kmsg
			elif [ "$thermal_type" == "4" ]; then
				echo 4 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 4 will be set 3 (high)" > /dev/kmsg
			fi
		else
				echo "[INBOX_FAN][AUTO]thermal fan will not  be set auto" > /dev/kmsg
		fi
	fi
	#check sys.asus.fan.mic++++
	mic_type_new=`getprop sys.asus.fan.mic`
	if [ "$mic_type_new" == "$mic_type" ];then
		echo "[INBOX_FAN][AUTO] mic_type_new=$mic_type_new mic_type=$mic_type" > /dev/kmsg
		exit 0
	else
		echo "[INBOX_FAN][AUTO]thermal fan set . 1st check mic_type=$mic_type; mic_type_new=$mic_type_new " > /dev/kmsg
		if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
			enable_mic
			exit 0
		else
			disable_mic
			exit 0
		fi
	fi

	mic_type_new=`getprop sys.asus.fan.mic`
	if [ "$mic_type_new" == "$mic_type" ];then
		exit 0
	else
		echo "[INBOX_FAN][AUTO]thermal fan set . 2nd check mic_type=$mic_type; mic_type_new=$mic_type_new " > /dev/kmsg
		if [ "$micfansettings_type" == "1" ] && [ "$mic_type_new" == "1" ]; then
			enable_mic
			exit 0
		else
			disable_mic
			exit 0
		fi
	fi
	#check sys.asus.fan.mic---
fi

