#!/bin/bash

# Get public IP
IP=$(curl -s ifconfig.me)

# Build domain
DOMAIN="${IP}.notionfaster.org"

# Certificate paths
CERT_DIR="/root/.acme.sh/${DOMAIN}_ecc"
CERT_PATH="${CERT_DIR}/fullchain.cer"
KEY_PATH="${CERT_DIR}/${DOMAIN}.key"

echo "Detected IP: ${IP}"
echo "Domain: ${DOMAIN}"

# Download config files
wget https://raw.githubusercontent.com/noyyyy/notion-reverse-proxy/dev/geocn.conf \
-O /etc/nginx/geocn.conf

wget https://raw.githubusercontent.com/noyyyy/notion-reverse-proxy/dev/nginx.conf \
-O /etc/nginx/nginx.conf

# Replace domain and certificate paths in nginx.conf
sed -i "s|server_name ;|server_name ${DOMAIN};|g" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate ;|ssl_certificate ${CERT_PATH};|g" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate_key ;|ssl_certificate_key ${KEY_PATH};|g" /etc/nginx/nginx.conf

echo "Configuration updated"

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    # Reload nginx
    nginx -s reload
    echo "Nginx reloaded successfully"
else
    echo "Nginx configuration test failed. Not reloading."
    exit 1
fi