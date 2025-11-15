#!/bin/sh

echo "--- MEMULAI SISTEM JOKES ---"

chmod +x mysql.sh
chmod +x myadmin.sh
chmod +x store_jokes.sh

if [ -z "$(docker network ls -q -f name=jokes-net)" ]; then
    echo "Membuat network: jokes-net"
    docker network create jokes-net
else
    echo "Network jokes-net sudah ada."
fi

./mysql.sh
./myadmin.sh
./store_jokes.sh

echo "Sistem keseluruhan telah dimulai."
