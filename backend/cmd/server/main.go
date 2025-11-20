package main

import (
	"log"
	"net/http"

	openapi "github.com/jonas59075/BerlinClock/backend/api/go"
)

func main() {
	log.Println("Berlin Clock API Server started at :8080")

	apiService := openapi.NewDefaultAPIService()
	apiController := openapi.NewDefaultAPIController(apiService)

	router := openapi.NewRouter(apiController)

	log.Fatal(http.ListenAndServe(":8080", router))
}
