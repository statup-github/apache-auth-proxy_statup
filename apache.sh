#!/bin/bash

set -e

# Insert cryptopassphrase. Create passphrase if none is set
touch /usr/local/apache2/conf/cryptopassphrase
chmod 0400 /usr/local/apache2/conf/cryptopassphrase
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/cryptopassphrase

sed -ri "s/replacemewithpassphrase/$(cat /usr/local/apache2/conf/cryptopassphrase)/g" /usr/local/apache2/conf/httpd.conf

# Insert the code that is used for healthchecks
# Fallback code if no value is set for the container
touch /usr/local/apache2/conf/healthcode
chmod 0400 /usr/local/apache2/conf/healthcode
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/healthcode

if [ ${#healthcode} -lt 16 ]; then healthcode=$(cat /usr/local/apache2/conf/healthcode); fi
if [ ${#healthcode} -lt 16 ]; then echo "healthcode not set or too short"; exit; fi

sed -ri "s/replacemewithhealthcode/${healthcode}/g" /usr/local/apache2/conf/httpd.conf


# Insert the code that is used for authenticating automated Selenium tests
# Fallback code if no value is set for the container
touch /usr/local/apache2/conf/testcode
chmod 0400 /usr/local/apache2/conf/testcode
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > /usr/local/apache2/conf/testcode

if [ ${#testcode} -lt 16 ]; then testcode=$(cat /usr/local/apache2/conf/testcode); fi
if [ ${#testcode} -lt 16 ]; then echo "testcode not set or too short"; exit; fi

sed -ri "s/replacemewithtestcode/${testcode}/g" /usr/local/apache2/conf/httpd.conf

httpd-foreground
