#!/bin/bash
set -euo pipefail

# for ubuntu:20.04 / Debian:10+ (validated on Debian 13)
NGINX_VERSION="1.19.4"
PCRE_VERSION="8.45"
RAW_BASE="https://raw.githubusercontent.com/noyyyy/notion-reverse-proxy/dev"

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR=""
if [ -f "$SCRIPT_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
fi

apt update
apt install -y build-essential libtool zlib1g-dev openssl libssl-dev libgeoip-dev geoip-database wget ca-certificates

wget "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O "nginx-${NGINX_VERSION}.tar.gz"
tar -zvxf "nginx-${NGINX_VERSION}.tar.gz"
rm "nginx-${NGINX_VERSION}.tar.gz"

wget "https://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz" -O "pcre-${PCRE_VERSION}.tar.gz"
tar -zvxf "pcre-${PCRE_VERSION}.tar.gz"
rm "pcre-${PCRE_VERSION}.tar.gz"

cd "nginx-${NGINX_VERSION}"

./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-stream_ssl_preread_module --with-stream --with-stream_geoip_module --with-pcre=../pcre-${PCRE_VERSION} --with-pcre-jit --with-cc-opt='-Wno-error=deprecated-declarations'
make -j"$(nproc)" && make install
mkdir -p /usr/logs /etc/nginx

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/nginx.service" ]; then
    cp "$SCRIPT_DIR/nginx.service" /usr/lib/systemd/system/nginx.service
else
    wget "$RAW_BASE/nginx.service" -O /usr/lib/systemd/system/nginx.service
fi

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/geocn.conf" ]; then
    cp "$SCRIPT_DIR/geocn.conf" /etc/nginx/geocn.conf
else
    wget "$RAW_BASE/geocn.conf" -O /etc/nginx/geocn.conf
fi

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/nginx.conf" ]; then
    cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/nginx.conf
else
    wget "$RAW_BASE/nginx.conf" -O /etc/nginx/nginx.conf
fi

mkdir -p /etc/nginx/ssl
if [ ! -f /etc/nginx/ssl/selfsigned.crt ] || [ ! -f /etc/nginx/ssl/selfsigned.key ]; then
    openssl req -x509 -nodes -newkey rsa:2048 -days 3650 -subj "/CN=localhost" \
        -keyout /etc/nginx/ssl/selfsigned.key \
        -out /etc/nginx/ssl/selfsigned.crt
fi

sed -i "s|server_name ;|server_name localhost;|g" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate ;|ssl_certificate /etc/nginx/ssl/selfsigned.crt;|g" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate_key ;|ssl_certificate_key /etc/nginx/ssl/selfsigned.key;|g" /etc/nginx/nginx.conf

nginx -t

if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload
    systemctl enable nginx.service
    systemctl start nginx.service
elif command -v service >/dev/null 2>&1 && [ -x /etc/init.d/nginx ]; then
    service nginx start
else
    nginx
fi

# ufw allow 22/tcp
# ufw allow 80/tcp
# ufw allow 443/tcp
# ufw enable -y

# echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
# echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# sysctl -p
