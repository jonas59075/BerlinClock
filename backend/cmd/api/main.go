package main

import (
    "log"
    "net/http"

    api "berlinclock/backend/gen/api_local/openapi"
    "github.com/go-chi/chi/v5"
    "github.com/go-chi/cors"
)

func main() {
    r := chi.NewRouter()

    r.Use(cors.Handler(cors.Options{
        AllowedOrigins: []string{"*"},
        AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowedHeaders: []string{"*"},
    }))

    // --- SWAGGER ---
    r.Get("/swagger/openapi.yaml", func(w http.ResponseWriter, r *http.Request) {
        http.ServeFile(w, r, "backend/gen/api_local/openapi/swagger/openapi.yaml")
    })
    r.Get("/", func(w http.ResponseWriter, r *http.Request){http.Redirect(w, r, "/swagger", 302)}); r.Mount("/swagger", api.SwaggerHandler()); r.Mount("/docs", http.FileServer(http.Dir("backend/docs")))

    log.Println("BerlinClock API listening on :8080")
    log.Fatal(http.ListenAndServe(":8080", r))
}
