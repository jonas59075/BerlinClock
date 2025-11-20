FROM golang:1.22 AS build

# Arbeitsverzeichnis = Projektroot
WORKDIR /app

# Modul-Dateien kopieren
COPY go.mod go.sum ./

# Abhängigkeiten holen
RUN go mod download

# Komplettes Repo kopieren
COPY . .

# Backend bauen
RUN CGO_ENABLED=0 GOOS=linux go build -o berlinclock-api ./backend/cmd/api

# Runtime-Stage
FROM alpine:3.20
WORKDIR /app
COPY --from=build /app/berlinclock-api .
EXPOSE 8080
docker compose build --no-cache && docker compose up
CMD ["./berlinclock-api"]
