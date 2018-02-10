FROM nntmux/alpine

# set labels
LABEL maintainer=Nightah

# set environment variables
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# install packages
RUN \
echo "**** install build packages ****" && \
apk add --no-cache --virtual=build-dependencies \
    curl && \
echo "**** add 3.2 alpine repo for pinned tmux version ****" && \
echo "http://dl-cdn.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories && \
echo "**** trust and add php repo ****" && \
curl -o /etc/apk/keys/php-alpine.rsa.pub https://php.codecasts.rocks/php-alpine.rsa.pub && \
echo "@php https://php.codecasts.rocks/v3.7/php-7.2" >> /etc/apk/repositories && \
apk add --no-cache \
    apache2-utils \
    ffmpeg \
    git \
    lame \
    libressl2.6-libssl \
    logrotate \
    mediainfo \
    nginx \
    openssl \
    p7zip \
    php7@php \
    php7-common@php \
    php7-ctype@php \
    php7-curl@php \
    php7-dev@php \
    php7-dom@php \
    php7-exif@php \
    php7-fpm@php \
    php7-gd@php \
    php7-iconv@php \
    php7-imagick@php \
    php7-json@php \
    php7-mbstring@php \
    php7-openssl@php \
    php7-pdo@php \
    php7-pdo_mysql@php \
    php7-pear@php \
    php7-phar@php \
    php7-session@php \
    php7-sockets@php \
    php7-xml@php \
    php7-zlib@php \
    tmux==2.0-r0 \
    unrar && \
echo '**** create php symlink ****' && \
ln -s /usr/bin/php7 /usr/bin/php && \
echo '**** install composer ****' && \
curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer && \
echo "**** configure nginx ****" && \
echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
    /etc/nginx/fastcgi_params && \
rm -f /etc/nginx/conf.d/default.conf && \
echo "**** fix logrotate ****" && \
sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
echo "**** cleanup ****" && \
    apk del --force --purge \
	build-dependencies && \
rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /app /config