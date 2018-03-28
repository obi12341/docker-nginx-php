FROM ubuntu:xenial
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN apt-get update \
	&& apt-get install -y apt-transport-https \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68576280 \
	&& echo 'deb https://deb.nodesource.com/node_6.x xenial main' > /etc/apt/sources.list.d/nodesource.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
	nginx \
	php-fpm \
	php-curl \
	php-gd \
	php-imagick \
	php-mysqlnd \
	php-memcached \
	php-cli \
	php-intl \
	php-apcu \
	php-redis \
	php-mcrypt \
	php-mbstring \
	php-xml \
	php-soap \
	php-zip \
	php-sqlite3 \
	php-ssh2 \
	supervisor \
	git \
	wget \
	nano \
	curl \
	mysql-client \
	graphicsmagick \
	imagemagick \
	ghostscript \
	openssh-client \
	mailutils \
	cron \
	rsyslog \
	net-tools \
	sudo \
	zip \
	postfix \
	unzip \
	nodejs \
	locales \
	gifsicle \
	jpegoptim \
	optipng \
	rsync \
	patch \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Putting everything in place
RUN rm -rf /etc/nginx/sites-enabled/* \
	&& mkdir -p /var/www/html \
	&& rm -f /var/www/html/* \
	&& mkdir -p /var/www/.ssh \
	&& mkdir -p /var/www/.composer \
	&& chown -R www-data:www-data /var/www \
	&& locale-gen de_DE.UTF-8 \
	&& locale-gen en_US.UTF-8 \
	&& ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
	&& mkdir /run/php \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& phpdismod igbinary

## Composer install
RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && chmod +x /bin/composer

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/mime.types /etc/nginx/mime.types
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY assets/postfix/main.cf /etc/postfix/main.cf
COPY assets/postfix/postfix-wrapper.sh /postfix-wrapper.sh

COPY assets/php.ini /etc/php/7.0/fpm/php.ini
COPY assets/php-cli.ini /etc/php/7.0/cli/php.ini
COPY assets/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY parent.sh /parent.sh
COPY start.sh /start.sh

## Tests
RUN nginx -t
RUN php-fpm7.0 -t

EXPOSE 80

CMD ["bash", "/start.sh"]
