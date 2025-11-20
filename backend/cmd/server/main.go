package main

import (
	"log"
	"net/http"
	openapi "github.com/jonas59075/BerlinClock/backend/api/go"
)

func main() {
	log.Printf("Server started on :8080")

	apiService := openapi.NewDefaultAPIService()
	apiController := openapi.NewDefaultAPIController(apiService)
	router := openapi.NewRouter(apiController)

	log.Fatal(http.ListenAndServe(":8080", router))
}
