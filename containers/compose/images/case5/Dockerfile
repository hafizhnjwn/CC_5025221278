#---------------------------------------------------------------------
# STAGE 1: "Builder"
# - Berisi Node.js
# - Tugasnya: Meng-compile aset (CSS/JS)
#---------------------------------------------------------------------
FROM node:18-alpine AS builder

WORKDIR /app

# Salin file resep (package.json)
# (Pastikan kamu sudah membuat file package.json)
COPY package.json .

# Instal dependencies (misal: sass, webpack, dll)
# (Kita simulasi saja agar cepat)
RUN npm install --package-lock-only

# Salin sisa source code
COPY . .

# Jalankan skrip build!
# Ini akan membuat folder 'html/assets/dist' di dalam image ini
RUN npm run build

#---------------------------------------------------------------------
# STAGE 2: "Final" (Produksi)
# - Ini adalah adaptasi dari Dockerfile-mu
# - Berisi Nginx + PHP-FPM (bukan Node.js!)
#---------------------------------------------------------------------
FROM nginx:1.15.12-alpine AS final

# Perintah RUN aslimu - sudah benar
RUN apk update && apk add php7-fpm supervisor git curl

# Paksa php-fpm7 untuk mendengarkan di port 9000 (sesuai nginx.conf)
RUN sed -i 's|listen = /run/php/php-fpm7.sock|listen = 127.0.0.1:9000|' /etc/php7/php-fpm.d/www.conf

# Konfigurasi Nginx aslimu (dibersihkan dari duplikasi)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# --- INI ADALAH PERUBAHAN UTAMA ---
# 1. Salin file HTML/PHP dasar (TANPA 'dist' yang lama)
#    (Pastikan kamu sudah 'rm -rf html/assets/dist' di komputermu)
COPY html/ /var/www/html/

# 2. Salin HANYA folder 'dist' yang sudah di-build dari stage 'builder'
COPY --from=builder /app/html/assets/dist /var/www/html/assets/dist
# --- AKHIR PERUBAHAN UTAMA ---

# Salin file konfigurasi dan skrip aslimu
# (Saya sesuaikan path supervisord.conf agar konsisten)
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

# Tambahan: Best practice agar skrip bisa dieksekusi
RUN chmod +x /start.sh

# Tambahan: Best practice untuk permissions
RUN chown -R nginx:nginx /var/www/html /var/cache/nginx

# Entrypoint aslimu (diubah sedikit agar lebih portabel)
ENTRYPOINT ["sh", "/start.sh"]
