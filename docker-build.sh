#!/bin/bash

echo building docker image

docker build -t lmldocker/php-test-connectivity:2.0 .

echo
echo Listing images ... :
docker image ls | grep 'lmldocker'
