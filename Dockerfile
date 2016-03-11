FROM ubuntu:precise
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

ENV TERM linux

RUN apt-get update && apt-get install -y \
	nginx \
	php5-fpm \
	php5-curl \
	php5-gd \
	php5-imagick \
	php5-mysql \
	php5-memcached \
	php5-memcache \
	php5-cli \
	php5-intl \
	php-apc \
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
	rsyslog \
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
	&& ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

## Composer
RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && chmod +x /bin/composer

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY assets/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf

COPY assets/php.ini /etc/php5/fpm/php.ini
COPY assets/php-cli.ini /etc/php5/cli/php.ini
RUN sed -i "s/;daemonize = yes/daemonize = no/" /etc/php5/fpm/php-fpm.conf
COPY assets/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY parent.sh /parent.sh

EXPOSE 80

CMD ["/usr/bin/supervisord"]
