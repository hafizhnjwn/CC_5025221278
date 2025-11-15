#!/bin/sh

echo "--- 3. Memulai container joke-storer ---"
docker rm -f joke-storer

chmod +x ./script/jokes.sh

# Perintah docker run yang sudah dimodifikasi
docker container run \
    -dit \
    --name joke-storer \
    --network jokes-net \
    -v "$(pwd)/script:/script" \
    alpine:3.18 \
    /bin/sh /script/jokes.sh

echo "Container joke-storer sedang berjalan."