number=`netstat -nat|grep -i "14:443" | grep ESTABLISHED | awk '{print $5}' | cut -f 1 -d ":" | uniq -c |  wc -l`


now=`date +%s`
curl https://npstatus.jerryw.cn/api/v1/metrics/1/points  \
  -H 'X-Cachet-Token: 123123'   \
  --header 'Content-Type: application/json' \
  --request POST \
  -d '{"value": '"$number"',"timestamp":'"$now"'}'


