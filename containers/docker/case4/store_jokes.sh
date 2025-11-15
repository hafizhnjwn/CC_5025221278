#!/bin/sh

# Membuat kontainer yang mengambil dan menyimpan jokes
echo "--- 3. Memulai container joke-storer ---"
docker rm -f joke-storer

# Perintah ini akan dijalankan DI DALAM kontainer Alpine
# Kita harus meng-escape tanda $ (menjadi \$) agar dievaluasi
# di dalam kontainer, bukan di host.
COMMAND_STRING=" \
    apk update && apk add curl jq mariadb-client; \
    echo 'Menunggu MySQL di host mysql1...'; \
    while ! mysqladmin ping -h'mysql1' -u'root' -p'mydb6789tyui' --silent; do \
        sleep 1; \
    done; \
    echo 'MySQL siap! MySQL terdeteksi.'; \
    
    MYSQL_CMD='mysql -h mysql1 -u root -pmydb6789tyui jokes'; \
    
    \$MYSQL_CMD -e 'CREATE TABLE IF NOT EXISTS jokes ( \
        id INT AUTO_INCREMENT PRIMARY KEY, \
        joke_text TEXT NOT NULL, \
        fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP \
    );'; \
    
    URL='https://api.chucknorris.io/jokes/random'; \
    echo 'Memulai loop pengambilan jokes...'; \
    
    while true; \
    do \
        echo 'Mengambil joke baru...'; \
        JOKE_VALUE=\$(curl -sL \$URL | jq -r '.value' | sed \"s/'/''/g\"); \
        
        if [ -n \"\$JOKE_VALUE\" ]; then \
            \$MYSQL_CMD -e \"INSERT INTO jokes (joke_text) VALUES ('\$JOKE_VALUE');\"; \
            echo 'Joke berhasil disimpan.'; \
        else \
            echo 'Gagal mengambil joke.'; \
        fi; \
        sleep 10; \
    done \
"

docker container run \
    -dit \
    --name joke-storer \
    --network jokes-net \
    alpine:3.18 \
    sh -c "$COMMAND_STRING"

echo "Container joke-storer sedang berjalan."
