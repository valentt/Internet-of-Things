# script that uplads temperature reading from temperature sensor running on openwrt

#!/bin/ash

# api key for open.sen.se
apikey=
roomfeed=

roomtemp=$(digitemp_DS9097 -a -q -o"%.2C" -c /root/.digitemprc)

# post to open.sen.se
curl 'http://api.sen.se/events/?sense_key='$apikey -X POST -H "Content-type: application/json" -d '[{"feed_id": '$roomfeed',"value": '$roomtemp'}]'
