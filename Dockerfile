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
curl -o /etc/apk/keys/phpearth.rsa.pub https://repos.php.earth/alpine/phpearth.rsa.pub && \
echo "@php https://repos.php.earth/alpine/v3.7" >> /etc/apk/repositories && \
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
    php7.2@php \
    php7.2-bcmath@php \
    php7.2-common@php \
    php7.2-ctype@php \
    php7.2-curl@php \
    php7.2-dev@php \
    php7.2-dom@php \
    php7.2-exif@php \
    php7.2-fileinfo@php \
    php7.2-fpm@php \
    php7.2-gd@php \
    php7.2-iconv@php \
    php7.2-imagick@php \
    php7.2-json@php \
    php7.2-mbstring@php \
    php7.2-openssl@php \
    php7.2-pdo@php \
    php7.2-pdo_mysql@php \
    php7.2-pear@php \
    php7.2-phar@php \
    php7.2-session@php \
    php7.2-simplexml@php \
    php7.2-sockets@php \
    php7.2-sodium@php \
    php7.2-tokenizer@php \
    php7.2-xml@php \
    php7.2-xmlwriter@php \
    php7.2-zlib@php \
    tmux==2.0-r0 \
    unrar && \
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