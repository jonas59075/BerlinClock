package api

import (
	"context"
	"strings"
	"time"
)

// DefaultAPIService is a simple, stateless implementation of the service interface.
type DefaultAPIService struct{}

// NewDefaultAPIService creates a new instance of DefaultAPIService.
func NewDefaultAPIService() DefaultAPIService {
	return DefaultAPIService{}
}

// TimeGet returns the current time as TimeResponse.
func (s DefaultAPIService) TimeGet(ctx context.Context) (ImplResponse, error) {
	now := time.Now()

	payload := TimeResponse{
		Hour:   int32(now.Hour()),
		Minute: int32(now.Minute()),
		Second: int32(now.Second()),
	}

	return Response(200, payload), nil
}

// BerlinClockGet returns the current time encoded as a BerlinClockState.
func (s DefaultAPIService) BerlinClockGet(ctx context.Context) (ImplResponse, error) {
	now := time.Now()
	state := computeBerlinClockState(now.Hour(), now.Minute(), now.Second())

	return Response(200, state), nil
}

// computeBerlinClockState computes the Berlin Clock state for a given time.
func computeBerlinClockState(hour, minute, second int) BerlinClockState {
	// Seconds lamp
	secondsLamp := "O"
	if second%2 == 0 {
		secondsLamp = "Y"
	}

	// Five-hour row (4 lamps)
	litFiveHour := hour / 5
	fiveHourRow := ""
	for i := 0; i < 4; i++ {
		if i < litFiveHour {
			fiveHourRow += "R"
		} else {
			fiveHourRow += "O"
		}
	}

	// One-hour row (4 lamps)
	restHour := hour % 5
	oneHourRow := ""
	for i := 0; i < 4; i++ {
		if i < restHour {
			oneHourRow += "R"
		} else {
			oneHourRow += "O"
		}
	}

	// Five-minute row (11 lamps)
	litFiveMinute := minute / 5
	fiveMinuteRow := ""
	for i := 0; i < 11; i++ {
		if i < litFiveMinute {
			// Jede dritte Lampe ist rot für die Viertelstunden
			if (i+1)%3 == 0 {
				fiveMinuteRow += "R"
			} else {
				fiveMinuteRow += "Y"
			}
		} else {
			fiveMinuteRow += "O"
		}
	}

	// One-minute row (4 lamps)
	restMinute := minute % 5
	oneMinuteRow := ""
	for i := 0; i < 4; i++ {
		if i < restMinute {
			oneMinuteRow += "Y"
		} else {
			oneMinuteRow += "O"
		}
	}

	return BerlinClockState{
		SecondsLamp:      secondsLamp,
		FiveHourRow:      fiveHourRow,
		OneHourRow:       oneHourRow,
		FiveMinuteRow:    fiveMinuteRow,
		OneMinuteRow:     oneMinuteRow,
		FiveHoursRow:     strings.Split(fiveHourRow, ""),
		SingleHoursRow:   strings.Split(oneHourRow, ""),
		FiveMinutesRow:   strings.Split(fiveMinuteRow, ""),
		SingleMinutesRow: strings.Split(oneMinuteRow, ""),
	}
}
