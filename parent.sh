#!/bin/bash

PHP_SESSION_SAVE_HANDLER=${PHP_SESSION_SAVE_HANDLER:-'memcached'}
PHP_SESSION_SAVE_PATH=${PHP_SESSION_SAVE_PATH:-'memcache:11211'}

POSTFIX_HOSTNAME=${POSTFIX_HOSTNAME:-example.com}
POSTFIX_PROTOCOL=${POSTFIX_PROTOCOL:-ipv4}
POSTFIX_RELAYHOST=${POSTFIX_RELAYHOST:-}

sed -i "s/session.save_handler = memcached/session.save_handler = ${PHP_SESSION_SAVE_HANDLER}/g" /etc/php/7.0/fpm/php.ini
sed -i "s#session.save_path = \"memcache:11211\"#session.save_path = \"${PHP_SESSION_SAVE_PATH}\"#g" /etc/php/7.0/fpm/php.ini

sed -i "s/{{POSTFIX_HOSTNAME}}/${POSTFIX_HOSTNAME}/" /etc/postfix/main.cf
sed -i "s/{{POSTFIX_PROTOCOL}}/${POSTFIX_PROTOCOL}/" /etc/postfix/main.cf
sed -i "s/{{POSTFIX_RELAYHOST}}/${POSTFIX_RELAYHOST}/" /etc/postfix/main.cf


