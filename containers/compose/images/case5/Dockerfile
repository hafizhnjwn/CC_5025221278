FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json .

RUN npm install --package-lock-only

COPY . .

RUN npm run build

FROM nginx:1.15.12-alpine AS final

RUN apk update && apk add php7-fpm supervisor git curl
RUN sed -i 's|listen = /run/php/php-fpm7.sock|listen = 127.0.0.1:9000|' /etc/php7/php-fpm.d/www.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY html/ /var/www/html/
COPY --from=builder /app/html/assets/dist /var/www/html/assets/dist
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh

RUN chown -R nginx:nginx /var/www/html /var/cache/nginx

ENTRYPOINT ["sh", "/start.sh"]
