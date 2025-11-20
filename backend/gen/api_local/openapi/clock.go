package openapi

import (
    "encoding/json"
    "net/http"
    "time"
)

func (s *Server) GetClockCurrent(w http.ResponseWriter, r *http.Request) {
    now := time.Now()
    resp := map[string]int{
        "hours":   now.Hour(),
        "minutes": now.Minute(),
        "seconds": now.Second(),
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(resp)
}
