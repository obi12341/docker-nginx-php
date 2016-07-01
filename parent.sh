#!/bin/bash

POSTFIX_HOSTNAME=${POSTFIX_HOSTNAME:-example.com}
POSTFIX_PROTOCOL=${POSTFIX_PROTOCOL:-ipv4}
sed -i "s/{{POSTFIX_HOSTNAME}}/${POSTFIX_HOSTNAME}/" /etc/postfix/main.cf
sed -i "s/{{POSTFIX_PROTOCOL}}/${POSTFIX_PROTOCOL}/" /etc/postfix/main.cf
