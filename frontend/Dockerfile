FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npx elm-tooling install
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
