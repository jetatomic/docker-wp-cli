FROM wordpress:latest

# install the PHP extensions
RUN apt-get update && apt-get install -y zlibc zlib1g zlib1g-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-install zip
