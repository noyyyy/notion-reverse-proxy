wget https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf \
    -O upstream_servers.list

sed -i 's/114.114.114.114/\]tls:\/\/dot.pub/g' upstream_servers.list
sed -i 's/server=/\[/g' upstream_servers.list
sed -i '1i tls://dns.google' upstream_servers.list