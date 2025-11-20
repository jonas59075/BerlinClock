package openapi

import (
    "log"
    "net/http"
)

func Run() {
    router := NewRouter()
    log.Println("BerlinClock API listening on :8080")
    log.Fatal(http.ListenAndServe(":8080", router))
}
