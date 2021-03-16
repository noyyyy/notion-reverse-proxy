#!/bin/bash
# 参考了 https://blog.51cto.com/manual/1977834
##########################################################
#使用curl命令检查http服务器的状态
#-m设置curl不管访问成功或失败，最大消耗的时间为5秒，5秒连接服务为相应则视为无法连接
#-s设置静默连接，不显示连接时的连接速度、时间消耗等信息
#-o将curl下载的页面内容导出到/dev/null(默认会在屏幕显示页面内容)
#-w设置curl命令需要显示的内容%{http_code}，指定curl返回服务器的状态码
check(){
       count=0
       while [ $count -le 4 ];
       do 
       status_code=$(curl -s -o /dev/null -w %{http_code} --resolve www.notion.so:443:$1 https://www.notion.so)
       #echo $status_code
       if [ $status_code -eq 200 ];then
              status=1
              break
       else
              count=`expr $count + 1`
              echo $count
              status=4
       fi
       done

       curl  --url  https://npstatus.jerryw.cn/api/v1/components/$2 \
       --request PUT \
       -H "X-Cachet-Token: $Token"  \
       -H 'Content-Type: application/json'  \
       -d '{"status": '"$status"'}'
}

s3check(){
       count=0
       while [ $count -le 4 ];
       do 
       status_code=$(curl -s -o /dev/null -w %{http_code} --resolve s3.us-west-2.amazonaws.com:443:$1 \
        https://s3.us-west-2.amazonaws.com )       
       if [ $status_code -eq 307 ];then
              status=1
              break
       else
              count=`expr $count + 1`
              echo $count
              status=4
       fi
       done

       curl  --url  https://npstatus.jerryw.cn/api/v1/components/$2 \
       --request PUT \
       -H "X-Cachet-Token: $Token"  \
       -H 'Content-Type: application/json'  \
       -d '{"status": '"$status"'}'
}


dotcheck(){
       count=0
       while [ $count -le 4 ];
       do 
       msg=$(getdns_query @49.234.153.60~$1 -m -s -L -A www.baidu.com | grep answer_type | wc -l)
       if [ $msg -gt 0 ];then
              status=1
              break
       else
              count=`expr $count + 1`
              echo $count
              status=4
       fi
       done
       curl  --url  https://npstatus.jerryw.cn/api/v1/components/$2 \
       --request PUT \
       -H "X-Cachet-Token: $Token"  \
       -H 'Content-Type: application/json'  \
       -d '{"status": '"$status"'}'
}

dohcheck()
{
       count=0
       while [ $count -le 4 ];
       do 
       status_code=$(curl -H 'accept: application/dns-message' \
         "$1?dns=UyQBAAABAAAAAAAAA3d3dwViYWlkdQNjb20AAAEAAQ"  -w %{http_code} -s -o /dev/null)       
       if [ $status_code -eq 200 ];then
              status=1
              break
       else
              count=`expr $count + 1`
              echo $count
              status=4
       fi
       done
       curl  --url  https://npstatus.jerryw.cn/api/v1/components/$2 \
       --request PUT \
       -H "X-Cachet-Token: $Token"  \
       -H 'Content-Type: application/json'  \
       -d '{"status": '"$status"'}'
}

Token=
check 119.28.13.121 1
check 194.56.79.104 10
check 45.133.119.184 12
check 156.255.213.41 13
s3check 119.28.13.121 7
s3check 194.56.79.104 11
dotcheck dns.jerryw.cn 8
dohcheck https://dns.jerryw.cn:8443/dns-query 9