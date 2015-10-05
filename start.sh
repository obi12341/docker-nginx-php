#!/bin/bash

SSMTP_ROOT=${SSMTP_ROOT:-test@example.com}
SSMTP_MAILHUB=${SSMTP_MAILHUB:-smtp.gmail.com:587}
SSMTP_REWRITE_DOMAIN=${SSMTP_REWRITE_DOMAIN:-gmail.com}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-localhost}
SSMTP_AUTH_USER=${SSMTP_AUTH_USER:-username}
SSMTP_AUTH_PASS=${SSMTP_AUTH_PASS:-password}
SSMTP_FROM_LINE_OVERRIDE=${SSMTP_FROM_LINE_OVERRIDE:-yes}

sed -i "s/{{SSMTP_ROOT}}/${SSMTP_ROOT}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_MAILHUB}}/${SSMTP_MAILHUB}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_REWRITE_DOMAIN}}/${SSMTP_REWRITE_DOMAIN}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_HOSTNAME}}/${SSMTP_HOSTNAME}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_AUTH_USER}}/${SSMTP_AUTH_USER}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_AUTH_PASS}}/${SSMTP_AUTH_PASS}/" /etc/ssmtp/ssmtp.conf
sed -i "s/{{SSMTP_FROM_LINE_OVERRIDE}}/${SSMTP_FROM_LINE_OVERRIDE}/" /etc/ssmtp/ssmtp.conf


/usr/bin/supervisord
