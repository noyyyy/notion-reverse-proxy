#for ubuntu:20:04

wget https://nginx.org/download/nginx-1.19.4.tar.gz 
tar -zvxf nginx-1.19.4.tar.gz 
rm nginx-1.19.4.tar.gz
cd nginx-1.19.4
sudo apt update
sudo apt install -y build-essential libtool zlib1g-dev openssl libpcre3 libpcre3-dev libssl-dev
./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-stream_ssl_preread_module  --with-stream 
make && make install
mkdir /usr/logs