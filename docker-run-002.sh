#!/bin/bash

# docker stop php-server
# docker rm php-server

## docker run --name php-server    -d                \
##  -p 1087:80                                      \
##  --restart=always                                  \
##  --cpus="1"                                        \
##  --memory="1g" --memory-reservation="900m"         \
##  -v /area6/docker/volume/ubuntu-lamp-server/client97/var-www-html:/www    \
##  lmldocker/php:1.0


########## $remote_file_name="http://$TEST_HOST:$TEST_PORT/$TEST_ENDPOINT";

docker run --name php-test-002                   \
 -p 5581:80                                      \
 --env TEST_HOST=192.168.1.9                     \
 --env TEST_PORT=5580                            \
 --env TEST_ENDPOINT=remote-content.php          \
 --env TEST_CONTENT='I-am-php-test-002-contanier-port-5581'         \
 --cpus="0.5"                                    \
 --memory="50m" --memory-reservation="50m"       \
 --rm                                            \
 lmldocker/php-test-connectivity:2.0






#--restart=always                                  \
#--rm                                            \

# docker exec -it php-server /bin/bash
