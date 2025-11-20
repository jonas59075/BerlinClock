# ---- Build Stage ----
FROM golang:1.22 AS builder
WORKDIR /app
COPY backend/ .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server gen/api_local/main.go

# ---- Runtime Stage ----
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
ENTRYPOINT ["./server"]
