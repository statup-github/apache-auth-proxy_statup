#!/bin/bash

set -e

# Create passphrase
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/cryptopassphrase
chmod 0400 /usr/local/apache2/conf/cryptopassphrase

# insert into config
sed -ri "s/replacemewithpassphrase/$(cat /usr/local/apache2/conf/cryptopassphrase)/g" /usr/local/apache2/conf/httpd.conf

httpd-foreground
