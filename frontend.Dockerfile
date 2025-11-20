FROM node:20 AS build
WORKDIR /app
COPY frontend .
RUN npm install -g elm && elm make src/Main.elm --optimize --output=dist/main.js

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf
