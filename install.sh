#for ubuntu:20:04/Debian:10

apt update
apt install -y build-essential libtool zlib1g-dev openssl libpcre3 libpcre3-dev libssl-dev libgeoip-dev

wget https://nginx.org/download/nginx-1.19.4.tar.gz  -O nginx-1.19.4.tar.gz 
tar -zvxf nginx-1.19.4.tar.gz 
rm nginx-1.19.4.tar.gz
cd nginx-1.19.4

./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-stream_ssl_preread_module  --with-stream --with-stream_geoip_module
make && make install
mkdir /usr/logs

wget https://raw.githubusercontent.com/Jerrywang959/notion-reverse-proxy/main/nginx.service 、
-O  /usr/lib/systemd/system/nginx.service

wget https://raw.githubusercontent.com/Jerrywang959/notion-reverse-proxy/main/geocn.conf \ 
-O /etc/nginx/geocn.conf

wget https://raw.githubusercontent.com/Jerrywang959/notion-reverse-proxy/main/nginx.conf \
-O  /etc/nginx/nginx.conf  

service nginx start
systemctl enable nginx.service

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
