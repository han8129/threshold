#syntax=docker/dockerfile:1

FROM node:18.13.0
RUN apt-get update && apt-get install -y redis
COPY --chmod=u=r redis.conf /usr/local/etc/redis/redis.conf
WORKDIR /usr/src/threshold
EXPOSE 80

RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci

USER node
COPY . .

CMD redis-server /usr/local/etc/redis/redis.conf \
    & node /usr/src/threshold/index.js
