# !/bin/bash

# sen.se
sense_apikey=
rpigpu_feed=
rpicpu_feed=

GPUOUT=`/opt/vc/bin/vcgencmd measure_temp`
CPUOUT=`cat /sys/class/thermal/thermal_zone0/temp`

GPU=`cut -c6-9 <<< $GPUOUT`
CPU=`cut -c1-2 <<< $CPUOUT`.`cut -c3-5 <<< $CPUOUT`
#CPU=`printf "%.1f\n" $CPU2`

echo CPU=$CPU
echo GPU=$GPU

curl 'http://api.sen.se/events/?sense_key='$sense_apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$rpigpu_feed',"value": '$GPU'}]'
curl 'http://api.sen.se/events/?sense_key='$sense_apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$rpicpu_feed',"value": '$CPU'}]'
echo -e "\n"
