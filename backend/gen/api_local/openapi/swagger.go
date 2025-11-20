package openapi

import (
    "embed"
    "net/http"
)

//go:embed swagger/*
var swaggerFS embed.FS

func SwaggerHandler() http.Handler {
    return http.FileServer(http.FS(swaggerFS))
}
