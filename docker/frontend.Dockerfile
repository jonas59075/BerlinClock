FROM node:20 AS build
WORKDIR /app
COPY frontend/ .
RUN npm install -g elm
RUN elm make src/Main.elm --optimize --output=main.js

FROM node:20
WORKDIR /app
COPY --from=build /app .
RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "-s", ".", "-l", "3000"]
