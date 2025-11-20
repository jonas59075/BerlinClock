FROM golang:1.22 AS build
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
WORKDIR /app/cmd/server
RUN CGO_ENABLED=0 GOOS=linux go build -o /server

FROM alpine:3.19
WORKDIR /root/
COPY --from=build /server .
EXPOSE 8080
ENTRYPOINT ["./server"]
