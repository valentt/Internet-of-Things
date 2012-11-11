#!/bin/bash

#open.sen.se
apikey=
gpufeed=12198
cpu1feed=12199
cpu2feed=12200
roomfeed=16542

#cosm
cosm_apikey=
cosm_temp1feed=70507
cosm_temp1feed_id=01

#post to open.sen.se
gputemp=$(nvclock -T | sed -ne "s/=> GPU temp.*: \([0-9]\+\).*/\1/p")
cpucore1=$(sensors -u | grep 'Core 0' -A 4 | grep temp1_input | awk '{print $2 }' |awk '{printf("%d\n",$1 + 0.5);}')
cpucore2=$(sensors -u | grep 'Core 1' -A 4 | grep temp1_input | awk '{print $2 }' |awk '{printf("%d\n",$1 + 0.5);}')
roomtemp=$(digitemp_DS9097 -a -q -o"%.2C")

curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$gpufeed',"value": '$gputemp'}]'
curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$cpu1feed',"value": '$cpucore1'}]'
curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$cpu2feed',"value": '$cpucore2'}]'
curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$roomfeed',"value": '$roomtemp'}]'
# curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$feedHC',"value": '$indexHC'},{"feed_id":'$feedHP',"value": '$indexHP'}]' 


#post to cosm
cat <<EOF | tee cosm.json
{
  "version":"1.0.0",
  "datastreams":[
      {"id":"$cosm_temp1feed_id", "current_value":"$roomtemp"}
  ]
}
EOF

curl --request PUT --data-binary @cosm.json --header "X-ApiKey: $cosm_apikey" --verbose http://api.cosm.com/v2/feeds/$cosm_temp1feed

rm cosm.json

