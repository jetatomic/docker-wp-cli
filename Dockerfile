FROM wordpress:latest

# install PHP extensions
# zlibc zlib1g 
RUN apt-get update && apt-get install -y \
	libjpeg-dev \
	zlib1g-dev \
	libpng-dev \
	nano \
	sudo \
	less \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli zip

# PHP Upload config
COPY php-uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# WPMUDEV Snapshot
COPY snapshot.tar.gz /var/www/html/wp-content/plugins/snapshot.tar.gz 

#WP Plugins
RUN cd /var/www/html/wp-content/plugins \
	&& curl -O https://downloads.wordpress.org/plugin/w3-total-cache.latest-stable.zip \
	&& curl -O https://downloads.wordpress.org/plugin/contact-form-7.latest-stable.zip \
	&& curl -O https://downloads.wordpress.org/plugin/wp-mail-smtp.latest-stable.zip \
	&& curl -O https://downloads.wordpress.org/plugin/wp-pgp-encrypted-emails.latest-stable.zip

# Add WP-CLI 
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

# Instantiate WP
# RUN wp core install --path=`/var/www/html` 

# Add WP Plugins
# RUN wp plugin install w3-total-cache contact-form-7 --activate --path=`/var/www/html` \
#	&& wp plugin install wp-mail-smtp wp-pgp-encrypted-emails --path=`/var/www/html`

# Upload Snapshot plugin
#RUN mkdir /var/www/html/wp-content \
#	&& mkdir /var/www/html/wp-content/plugins

RUN tar -xvzf /var/www/html/wp-content/plugins/snapshot.tar.gz #\
#	&& rm  /var/www/html/wp-content/plugins/snapshot.tar.gz

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
