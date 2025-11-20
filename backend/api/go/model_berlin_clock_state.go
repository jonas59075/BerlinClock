package api

type BerlinClockState struct {
	SecondsLamp string `json:"secondsLamp"`
	FiveHourRow string `json:"fiveHourRow"`
	OneHourRow string `json:"oneHourRow"`
	FiveMinuteRow string `json:"fiveMinuteRow"`
	OneMinuteRow string `json:"oneMinuteRow"`
}
