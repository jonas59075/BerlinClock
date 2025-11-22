package main

import (
	openapi "github.com/jonas59075/berlinclock/backend/api/go"
	"log"
	"net/http"
)

func main() {
	log.Printf("Server started on :8080")

	apiService := openapi.NewDefaultAPIService()
	apiController := openapi.NewDefaultAPIController(apiService)
	router := openapi.NewRouter(apiController)

	log.Fatal(http.ListenAndServe(":8080", withCORS(router)))
}

func withCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}

		next.ServeHTTP(w, r)
	})
}
