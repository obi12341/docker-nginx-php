FROM ubuntu:trusty
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

RUN apt-get update && apt-get install -y \
	nginx \
	php5-fpm \
	php5-curl \
	php5-gd \
	php5-imagick \
	php5-mysqlnd \
	php5-cli \
	supervisor \
	git \
	&& apt-get clean

##Clean Up
RUN rm -rf /etc/nginx/sites-enabled/*
RUN mkdir -p /var/www/html
RUN chown www-data:www-data /var/www/html

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params

EXPOSE 80

CMD ["/usr/bin/supervisord"]
