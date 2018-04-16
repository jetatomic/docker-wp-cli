FROM wordpress:latest

# install PHP extensions
# zlibc zlib1g 
RUN apt-get update && apt-get install -y wget libjpeg-dev mysql-client zlib1g-dev libpng-dev nano less \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli zip

# Add WP-CLI
RUN curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /bin/wp \
	&& wp --info --allow-root
	
# Add WP Plugins
RUN wp plugin install w3-total-cache contact-form-7 --activate \
	&& wp plugin install wp-mail-smtp wp-pgp-encrypted-emails

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
