#!/bin/bash

set -e

# Create passphrase
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/cryptopassphrase
chmod 0400 /usr/local/apache2/conf/cryptopassphrase

# insert into config
sed -ri "s/replacemewithpassphrase/$(cat /usr/local/apache2/conf/cryptopassphrase)/g" /usr/local/apache2/conf/httpd.conf

# Insert the code that is used for authentication the Selenium test IDE
# Fallback code if no value is set for the container
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/testcode
chmod 0400 /usr/local/apache2/conf/testcode

if [ ${#testcode} -lt 16 ]; then testcode=$(cat /usr/local/apache2/conf/testcode); fi
if [ ${#testcode} -lt 16 ]; then echo "testcode not set or too short"; exit; fi

# Insert the code that is used for authentication the Selenium test IDE
sed -ri "s/replacemewithtestcode/${testcode}/g" /usr/local/apache2/conf/httpd.conf

httpd-foreground
