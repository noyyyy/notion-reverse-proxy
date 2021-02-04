number=`netstat -nat|grep -i "160.116.52.26:443" | grep ESTABLISHED | awk '{print $5}' | cut -f 1 -d ":" | uniq -c |  wc -l`

curl https://npstatus.jerryw.cn/api/v1/metrics/2/points  \
  -H 'X-Cachet-Token: 123123'   \
  --header 'Content-Type: application/json' \
  --request POST \
  -d '{"value": '"$number"'}'