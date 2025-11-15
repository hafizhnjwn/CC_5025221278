#!/bin/sh

# Membuat kontainer phpMyAdmin
echo "--- 2. Memulai container phpmyadmin1 ---"
docker rm -f phpmyadmin1

docker container run \
    -dit \
    --name phpmyadmin1 \
    --network jokes-net \
    -p 10000:80 \
    -e PMA_HOST=mysql1 \
    -e MYSQL_ROOT_PASSWORD=mydb6789tyui \
    phpmyadmin:5.2.1-apache

echo "Container phpmyadmin1 dimulai di http://localhost:10000"
