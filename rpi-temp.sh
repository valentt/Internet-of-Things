# !/bin/bash

# sen.se
sense_apikey=
rpigpu_feed=
rpicpu_feed=

function GPU-TEMP {
GPUOUT=`/opt/vc/bin/vcgencmd measure_temp`
GPU=`cut -c6-9 <<< $GPUOUT`
}

function CPU-TEMP {
CPUOUT=`cat /sys/class/thermal/thermal_zone0/temp`
CPU=`cut -c1-2 <<< $CPUOUT`.`cut -c3-5 <<< $CPUOUT`
}
#CPU=`printf "%.1f\n" $CPU2`

function sense-upload {
curl 'http://api.sen.se/events/?sense_key='$sense_apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$rpigpu_feed',"value": '$GPU'}]'
curl 'http://api.sen.se/events/?sense_key='$sense_apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$rpicpu_feed',"value": '$CPU'}]'
}

function average-cpu() 
{
cpuav=0
for i in 1 2 3
do
  CPU-TEMP
  echo $CPU
  local cpuav$i=$CPU
  local cpuav=$(`echo "scale=3; ($cpuav + $cpuav$i)|bc"`)
  echo $cpuav$i
  sleep 5
done
echo "scale=1; $CPUAV / $i"|bc
}

average-cpu
GPU-TEMP
CPU-TEMP
sense-upload
