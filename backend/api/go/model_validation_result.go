package api

type ValidationResult struct {
	Valid bool `json:"valid"`
	ErrorMessage string `json:"errorMessage,omitempty"`
}
