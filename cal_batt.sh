#!/sbin/busybox sh
SLEEP=500
 
if [ -e /data/.jbx/battery-calibrated ] ; then
        exit 0
fi
 
(
while : ; do
	#in case we might want to cancel the calibration by creating the file
	if [ -e /data/.jbx/battery-calibrated ] ; then
        	exit 0
	fi
        LEVEL=$(cat /sys/devices/platform/cpcap_battery/power_supply/battery/charge_counter)
        CURR_ADC=$(cat /sys/devices/platform/cpcap_battery/power_supply/battery/temp)
        STATUS=$(cat /sys/devices/platform/cpcap_battery/power_supply/battery/status)
        BATTFULL=$(cat /sys/devices/platform/cpcap_battery/power_supply/battery/capacity)
        if [ "$LEVEL" == "100" ] && [ "$BATTFULL" == "100" ]; then
                log -p i -t battery-calibration "*** LEVEL: $LEVEL CUR: $CURR_ADC***: calibrating..."
                rm -f /data/system/batterystats.bin
		mkdir /data/.jbx
		chmod 777 /data/.jbx
                touch /data/.jbx/battery-calibrated
                exit 0
        fi
        # log -p i -t battery-calibration "*** LEVEL: $LEVEL CUR: $CUR ***: sleeping for $SLEEP s..."
        sleep $SLEEP
done
) &
