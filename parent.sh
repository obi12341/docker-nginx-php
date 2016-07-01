#!/bin/bash

POSTFIX_HOSTNAME=${POSTFIX_HOSTNAME:-example.com}
sed -i "s/{{POSTFIX_HOSTNAME}}/${POSTFIX_HOSTNAME}/" /etc/postfix/main.cf
