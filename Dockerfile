FROM ubuntu:xenial
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

ENV TERM linux

RUN apt-get update && apt-get install -y \
	nginx \
	php-fpm \
	php-curl \
	php-gd \
	php-imagick \
	php-mysqlnd \
	php-memcached \
	php-memcache \
	php-cli \
	php-intl \
	php-apcu \
	php-redis \
	php-mcrypt \
	php-mbstring \
	supervisor \
	git \
	wget \
	nano \
	curl \
	mysql-client \
	graphicsmagick \
	imagemagick \
	openssh-client \
	ssmtp \
	mailutils \
	cron \
	rsyslog \
	net-tools \
	sudo \
	zip \
	unzip \
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
	&& ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
	&& mkdir /run/php \
	&& phpdismod igbinary

## Composer install
RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && chmod +x /bin/composer

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/mime.types /etc/nginx/mime.types
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params

COPY assets/php.ini /etc/php7.0/fpm/php.ini
COPY assets/php-cli.ini /etc/php7.0/cli/php.ini
COPY assets/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY parent.sh /parent.sh
COPY start.sh /start.sh

EXPOSE 80

CMD ["bash", "/start.sh"]
