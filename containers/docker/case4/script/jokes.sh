#!/bin/sh

# 1. Instal dependencies
apk update && apk add curl jq mariadb-client

# 2. Tunggu MySQL siap
echo 'Menunggu MySQL di host mysql1...'
while ! mysqladmin ping -h'mysql1' -u'root' -p'mydb6789tyui' --silent; do
    sleep 1
done
echo 'MySQL siap! MySQL terdeteksi.'

# 3. Siapkan Perintah MySQL dan Buat Tabel
MYSQL_CMD='mysql -h mysql1 -u root -pmydb6789tyui jokes'

$MYSQL_CMD -e 'CREATE TABLE IF NOT EXISTS jokes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    joke_text TEXT NOT NULL,
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);'

# 4. Mulai loop untuk mengambil jokes
URL='https://api.chucknorris.io/jokes/random'
echo 'Memulai loop pengambilan jokes...'

while true
do
    echo 'Mengambil joke baru...'
    
    # Ambil joke, parse dengan jq, dan escape single quotes (') menjadi ('') untuk SQL
    JOKE_VALUE=$(curl -sL $URL | jq -r '.value' | sed "s/'/''/g")
    
    if [ -n "$JOKE_VALUE" ]; then
        # Masukkan joke ke database
        $MYSQL_CMD -e "INSERT INTO jokes (joke_text) VALUES ('$JOKE_VALUE');"
        echo 'Joke berhasil disimpan.'
    else
        echo 'Gagal mengambil joke.'
    fi
    
    # Tunggu 10 detik sebelum mengambil lagi
    sleep 10
done
