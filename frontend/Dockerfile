FROM node:20

RUN npm install -g elm && npm install -g serve

WORKDIR /app
COPY . .

RUN elm make src/Main.elm --optimize --output=main.js

EXPOSE 3000
CMD ["serve", "-s", ".", "-l", "3000"]
