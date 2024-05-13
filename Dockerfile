FROM node:14 AS builder

WORKDIR /home/node/bc

COPY package*.json ./

RUN npm ci -q

COPY .env ./
COPY tsconfig.json ./
COPY src ./src
COPY typings ./typings
COPY public ./public
COPY vcs ./vcs

RUN npm run build

FROM nginx AS http

COPY --from=builder  /home/node/bc/build /var/www/html
COPY ./nginx-config/default.conf /etc/nginx/conf.d/default.conf

FROM staticfloat/nginx-certbot AS https

COPY --from=builder  /home/node/bc/build /var/www/html
