FROM php:8.3-cli

RUN apt-get update \
    # install GraphicsMagick
	&& apt-get install -y \
		libgraphicsmagick1-dev graphicsmagick zlib1g-dev libicu-dev libpq-dev gcc g++ --no-install-recommends \
	&& pecl -vvv install gmagick-beta && docker-php-ext-enable gmagick \
    # pdo_mysql
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    # redis
    && pecl install redis && docker-php-ext-enable redis \
	# intl
	&& docker-php-ext-configure intl && docker-php-ext-install intl \
    # tools
    && apt-get install -y unzip git vim default-mysql-client \
    # xdebug \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    # cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD /docker/entrypoint.sh /

ADD /docker/config-files/error-reporting.ini /usr/local/etc/php/conf.d/error-reporting.ini
ADD /docker/config-files/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
ADD /docker/config-files/upload-limit-php.ini /usr/local/etc/php/conf.d/upload-limit-php.ini
ADD /docker/config-files/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN mkdir -p /app/DistributionPackages
RUN mkdir -p /app/Configuration/Development/Postgres
RUN mkdir -p /app/Data/Logs/Exceptions
RUN mkdir -p /.composer

RUN chown -R 1000:1000 entrypoint.sh /app /.composer
RUN chmod +x entrypoint.sh

USER 1000:1000

WORKDIR /app

ENTRYPOINT [ "/entrypoint.sh" ]
