package api

// TimeResponse wird von GetTime() zurückgegeben.
type TimeResponse struct {
	Hour   int32 `json:"hour"`
	Minute int32 `json:"minute"`
	Second int32 `json:"second"`
}
