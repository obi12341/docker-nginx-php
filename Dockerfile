FROM ubuntu:trusty
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN apt-get update \
	&& apt-get install -y apt-transport-https \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68576280 \
	&& echo 'deb https://deb.nodesource.com/node_6.x trusty main' > /etc/apt/sources.list.d/nodesource.list \
	&& apt-get update && apt-get install -y \
	nginx \
	php5-fpm \
	php5-curl \
	php5-gd \
	php5-imagick \
	php5-mysqlnd \
	php5-memcached \
	php5-cli \
	php5-intl \
	php5-apcu \
	php5-redis \
	php5-mcrypt \
	libssh2-php \
	supervisor \
	git \
	wget \
	nano \
	curl \
	mysql-client \
	graphicsmagick \
	imagemagick \
	openssh-client \
	mailutils \
	postfix \
	gifsicle \
	jpegoptim \
	optipng \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Putting everything in place
RUN rm -rf /etc/nginx/sites-enabled/* \
	&& mkdir -p /var/www/html \
	&& mkdir -p /var/www/.ssh \
	&& mkdir -p /var/www/.composer \
	&& chown -R www-data:www-data /var/www \
	&& locale-gen de_DE.UTF-8 \
	&& locale-gen en_US.UTF-8 \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

## Composer install
RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && chmod +x /bin/composer

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/mime.types /etc/nginx/mime.types
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY assets/postfix/main.cf /etc/postfix/main.cf
COPY assets/postfix/postfix-wrapper.sh /postfix-wrapper.sh

COPY assets/php.ini /etc/php5/fpm/php.ini
COPY assets/php-cli.ini /etc/php5/cli/php.ini
COPY assets/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf
COPY parent.sh /parent.sh
COPY start.sh /start.sh

## Tests
RUN nginx -t
RUN php5-fpm -t

EXPOSE 80

CMD ["bash", "/start.sh"]
