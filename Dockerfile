# https://hub.docker.com/_/php
FROM php:7.4-cli

COPY ./www /www
COPY ./php.ini /php-ini

# RUN apt update
# RUN apt install php-mysqli -y

CMD php -S 0.0.0.0:80 -t /www -c /php.ini
