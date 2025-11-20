FROM node:20-alpine AS build

WORKDIR /app/frontend

# Elm-Tooling
RUN npm install -g elm

# Elm-Projekt kopieren
COPY frontend/elm.json ./elm.json
COPY frontend/index.html ./index.html
COPY frontend/src ./src

# Build
RUN mkdir -p /app/dist && \
    elm make src/Main.elm --optimize --output=/app/dist/main.js

FROM nginx:alpine

# statische Dateien
COPY frontend/index.html /usr/share/nginx/html/index.html
COPY --from=build /app/dist/main.js /usr/share/nginx/html/main.js

EXPOSE 80
