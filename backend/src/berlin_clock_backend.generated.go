package berlinclock

import (
	"fmt"

	api "github.com/jonas59075/BerlinClock/backend/api/go"
)

// TimeInput represents the domain time input.
type TimeInput struct {
	Hour   int
	Minute int
	Second int
}

// BerlinClockState represents the domain state of the Berlin Clock.
type BerlinClockState struct {
	SecondsLamp   string
	FiveHourRow   string
	OneHourRow    string
	FiveMinuteRow string
	OneMinuteRow  string
}

// ValidateTimeInput validates the given TimeInput.
func ValidateTimeInput(input TimeInput) error {
	if input.Hour < 0 || input.Hour > 23 {
		return fmt.Errorf("hour must be between 0 and 23")
	}
	if input.Minute < 0 || input.Minute > 59 {
		return fmt.Errorf("minute must be between 0 and 59")
	}
	if input.Second < 0 || input.Second > 59 {
		return fmt.Errorf("second must be between 0 and 59")
	}
	return nil
}

// ComputeBerlinClockState computes the BerlinClockState.
func ComputeBerlinClockState(input TimeInput) BerlinClockState {
	var secondsLamp string
	if input.Second%2 == 0 {
		secondsLamp = "X"
	} else {
		secondsLamp = "O"
	}

	// Five-hour row
	litFiveHour := input.Hour / 5
	fiveHourRow := ""
	for i := 0; i < 4; i++ {
		if i < litFiveHour {
			fiveHourRow += "X"
		} else {
			fiveHourRow += "O"
		}
	}

	// One-hour row
	restHour := input.Hour % 5
	oneHourRow := ""
	for i := 0; i < 4; i++ {
		if i < restHour {
			oneHourRow += "X"
		} else {
			oneHourRow += "O"
		}
	}

	// Five-minute row
	litFiveMinute := input.Minute / 5
	fiveMinuteRow := ""
	for i := 0; i < 11; i++ {
		if i < litFiveMinute {
			if (i+1)%3 == 0 {
				fiveMinuteRow += "R"
			} else {
				fiveMinuteRow += "Y"
			}
		} else {
			fiveMinuteRow += "O"
		}
	}

	// One-minute row
	restMinute := input.Minute % 5
	oneMinuteRow := ""
	for i := 0; i < 4; i++ {
		if i < restMinute {
			oneMinuteRow += "Y"
		} else {
			oneMinuteRow += "O"
		}
	}

	return BerlinClockState{
		SecondsLamp:   secondsLamp,
		FiveHourRow:   fiveHourRow,
		OneHourRow:    oneHourRow,
		FiveMinuteRow: fiveMinuteRow,
		OneMinuteRow:  oneMinuteRow,
	}
}

// ConvertToAPIModel maps a domain BerlinClockState to API BerlinClockState.
func ConvertToAPIModel(state BerlinClockState) *api.BerlinClockState {
	return &api.BerlinClockState{
		SecondsLamp:   state.SecondsLamp,
		FiveHourRow:   state.FiveHourRow,
		OneHourRow:    state.OneHourRow,
		FiveMinuteRow: state.FiveMinuteRow,
		OneMinuteRow:  state.OneMinuteRow,
	}
}

// ApiControllerImpl implements the generated controller interface.
type ApiControllerImpl struct{}

func NewApiControllerImpl() *ApiControllerImpl {
	return &ApiControllerImpl{}
}

// GetBerlinClock handles /berlin-clock requests.
func (s *ApiControllerImpl) GetBerlinClock(hour, minute, second int32) (api.BerlinClockState, error) {
	input := TimeInput{
		Hour:   int(hour),
		Minute: int(minute),
		Second: int(second),
	}

	if err := ValidateTimeInput(input); err != nil {
		return api.BerlinClockState{}, err
	}

	state := ComputeBerlinClockState(input)
	return *ConvertToAPIModel(state), nil
}

// GetTime handles /time requests.
func (s *ApiControllerImpl) GetTime() (api.TimeResponse, error) {
	return api.TimeResponse{
		Hour:   12,
		Minute: 34,
		Second: 56,
	}, nil
}
