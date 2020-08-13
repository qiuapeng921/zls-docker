#!/bin/sh

echo
echo "============================================"
echo "Install extensions from   : ${MORE_EXTENSION_INSTALLER}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Multicore Compilation     : ${MC}"
echo "Work directory            : ${PWD}"
echo "============================================"
echo


if [ -z "${EXTENSIONS##*,mcrypt,*}" ]; then
    echo "---------- mcrypt was REMOVED from PHP 7.2.0 ----------"
fi


if [ -z "${EXTENSIONS##*,mysql,*}" ]; then
    echo "---------- mysql was REMOVED from PHP 7.0.0 ----------"
fi


if [ -z "${EXTENSIONS##*,sodium,*}" ]; then
    echo "---------- Install sodium ----------"
    echo "Sodium is bundled with PHP from PHP 7.2.0 "
fi

if [ -z "${EXTENSIONS##*,swoole,*}" ]; then
    echo "---------- Install swoole ----------"
    # git clone --depth=1
    cd /tmp/extensions
    curl -o ./swoole.tar.gz https://github.com/swoole/swoole-src/archive/master.tar.gz -L && \
    tar zxvf ./swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure \
    --enable-openssl \
    --enable-http2 && \
    make clean && make && make install
    # pecl install swoole \
    docker-php-ext-enable swoole
fi

# if [ -z "${EXTENSIONS##*,swoole_tracker,*}" ]; then
#     echo "---------- Install swoole_tracker ----------"
#     cd /tmp/extensions
#     chmod +x ./swoole-tracker-install.sh && \
#     ./swoole-tracker-install.sh && \
#     rm ./swoole-tracker-install.sh
#     echo -e "\033[32m echo -e 'extension=/usr/local/etc/php/swoole-tracker/swoole_tracker73.so\napm.enable=1\napm.sampling_rate=100' > /usr/local/etc/php/conf.d/swoole-tracker.ini \033[0m"
#     cp -r swoole-tracker /usr/local/etc/php/
# fi

if [ -z "${EXTENSIONS##*,mongodb,*}" ]; then
    echo "---------- Install mongodb ----------"
    pecl install mongodb
    docker-php-ext-enable mongodb
fi

if [ -z "${EXTENSIONS##*,yaf,*}" ]; then
    echo "---------- Install yaf ----------"
    pecl install yaf
    docker-php-ext-enable yaf
fi

if [ -z "${EXTENSIONS##*,amqp,*}" ]; then
    echo "---------- Install amqp ----------"
    apk add --no-cache rabbitmq-c-dev
    cd /tmp/extensions
    pecl install amqp-1.9.4.tgz
    docker-php-ext-enable amqp
fi

if [ -z "${EXTENSIONS##*,redis,*}" ]; then
    echo "---------- Install redis ----------"
    mkdir redis \
    && tar -xf redis-4.3.0.tgz -C redis --strip-components=1 \
    && ( cd redis && phpize && ./configure && make ${MC} && make install ) \
    && docker-php-ext-enable redis
fi

if [ -z "${EXTENSIONS##*,memcached,*}" ]; then
    echo "---------- Install memcached ----------"
    apk add --no-cache libmemcached-dev zlib-dev
    printf "\n" | pecl install memcached-3.1.3
    docker-php-ext-enable memcached
fi

if [ -z "${EXTENSIONS##*,xdebug,*}" ]; then
    echo "---------- Install xdebug ----------"
    cd /tmp/extensions
    tar -xf xdebug-2.6.1.tgz -C xdebug --strip-components=1 \
    && ( cd xdebug && phpize && ./configure && make ${MC} && make install ) \
    && docker-php-ext-enable xdebug
fi

if [ -z "${EXTENSIONS##*,pdo_sqlsrv,*}" ]; then
    echo "---------- Install pdo_sqlsrv ----------"
    apk add --no-cache unixodbc-dev
    pecl install pdo_sqlsrv
    docker-php-ext-enable pdo_sqlsrv
fi

if [ -z "${EXTENSIONS##*,sqlsrv,*}" ]; then
    echo "---------- Install sqlsrv ----------"
    apk add --no-cache unixodbc-dev
    printf "\n" | pecl install sqlsrv
    docker-php-ext-enable sqlsrv
fi
