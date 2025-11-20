FROM golang:1.22 AS build

WORKDIR /app

# nur backend kopieren (nicht das ganze Projekt)
COPY backend/ ./backend/

WORKDIR /app/backend

RUN go mod download

WORKDIR /app/backend/cmd/server
RUN CGO_ENABLED=0 GOOS=linux go build -o /server

FROM alpine:3.19
COPY --from=build /server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
