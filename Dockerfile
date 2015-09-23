FROM ubuntu:trusty
MAINTAINER Patrick Oberdorf <patrick@oberdorf.net>

ENV TERM linux

RUN apt-get update && apt-get install -y \
	nginx \
	php5-fpm \
	php5-curl \
	php5-gd \
	php5-imagick \
	php5-mysqlnd \
	php5-memcached \
	php5-memcache \
	php5-cli \
	php5-apcu \
	php5-redis \
	supervisor \
	git \
	wget \
	nano \
	curl \
	mysql-client \
	graphicsmagick \
	imagemagick \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## Putting everything in place
RUN rm -rf /etc/nginx/sites-enabled/* \
	&& mkdir -p /var/www/html \
	&& mkdir -p /var/www/.ssh \
	&& chown -R www-data:www-data /var/www

## Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && chmod +x /bin/composer

COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY assets/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/nginx/vhost.conf /etc/nginx/sites-enabled/vhost.conf
COPY assets/nginx/fastcgi_params /etc/nginx/fastcgi_params

COPY assets/php.ini /etc/php5/fpm/php.ini

EXPOSE 80

CMD ["/usr/bin/supervisord"]
