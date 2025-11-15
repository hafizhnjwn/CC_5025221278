#!/bin/sh

# Membuat kontainer database MySQL
echo "--- 1. Memulai container mysql1 ---"
docker rm -f mysql1

docker container run \
    -dit \
    --name mysql1 \
    --network jokes-net \
    -v $(pwd)/dbdata:/var/lib/mysql \
    -e MYSQL_DATABASE=jokes \
    -e MYSQL_ROOT_PASSWORD=mydb6789tyui \
    -e MYSQL_ROOT_HOST=% \
    mysql:8.0 \
    --default-authentication-plugin=mysql_native_password

echo "Container mysql1 sedang dimulai..."
