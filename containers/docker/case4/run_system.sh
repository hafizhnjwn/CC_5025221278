#!/bin/sh

echo "--- MEMULAI SISTEM JOKES ---"

# 1. Pastikan semua skrip bisa dieksekusi
chmod +x mysql.sh
chmod +x myadmin.sh
chmod +x store_jokes.sh

# 2. Buat network (jika belum ada)
if [ -z "$(docker network ls -q -f name=jokes-net)" ]; then
    echo "Membuat network: jokes-net"
    docker network create jokes-net
else
    echo "Network jokes-net sudah ada."
fi

# 3. Jalankan semua skrip
./mysql.sh
./myadmin.sh
./store_jokes.sh

echo "---------------------------------------"
echo "--- SISTEM SELESAI DIJALANKAN! ---"
echo "---                               ---"
echo "Cek status semua container dengan:"
echo "docker ps"
echo ""
echo "Akses phpMyAdmin di:"
echo "http://<IP_SERVER_ANDA>:10000"
echo ""
echo "Lihat log penyimpan jokes dengan:"
echo "docker logs -f joke-storer"
echo "---------------------------------------"
