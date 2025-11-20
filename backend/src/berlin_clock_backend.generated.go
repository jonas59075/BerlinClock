package berlinclock

import (
	"fmt"

	api "backend/gen/api/go"
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

// ValidateTimeInput validates the given TimeInput according to domain invariants.
// Returns nil if valid, otherwise an error describing the violation.
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

// ComputeBerlinClockState computes the BerlinClockState for a given valid TimeInput.
func ComputeBerlinClockState(input TimeInput) BerlinClockState {
	// Seconds lamp
	var secondsLamp string
	if input.Second%2 == 0 {
		secondsLamp = "X"
	} else {
		secondsLamp = "O"
	}

	// Five hour row
	litFiveHour := input.Hour / 5
	fiveHourRow := ""
	for i := 0; i < 4; i++ {
		if i < litFiveHour {
			fiveHourRow += "X"
		} else {
			fiveHourRow += "O"
		}
	}

	// One hour row
	restHour := input.Hour % 5
	oneHourRow := ""
	for i := 0; i < 4; i++ {
		if i < restHour {
			oneHourRow += "X"
		} else {
			oneHourRow += "O"
		}
	}

	// Five minute row
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

	// One minute row
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

// ConvertToAPIModel maps a domain BerlinClockState to the OpenAPI ApiBerlinClockState DTO.
func ConvertToAPIModel(state BerlinClockState) *api.ApiBerlinClockState {
	return &api.ApiBerlinClockState{
		SecondsLamp:   state.SecondsLamp,
		FiveHourRow:   state.FiveHourRow,
		OneHourRow:    state.OneHourRow,
		FiveMinuteRow: state.FiveMinuteRow,
		OneMinuteRow:  state.OneMinuteRow,
	}
}

// ApiControllerImpl implements the generated ApiController interface.
type ApiControllerImpl struct{}

// NewApiControllerImpl returns a new ApiControllerImpl.
func NewApiControllerImpl() *ApiControllerImpl {
	return &ApiControllerImpl{}
}

// GetBerlinClock implements the OpenAPI endpoint for computing the Berlin Clock state.
func (s *ApiControllerImpl) GetBerlinClock(req *api.ApiTimeInput) (*api.ApiBerlinClockState, error) {
	input := TimeInput{
		Hour:   int(req.Hour),
		Minute: int(req.Minute),
		Second: int(req.Second),
	}
	if err := ValidateTimeInput(input); err != nil {
		return nil, err
	}
	state := ComputeBerlinClockState(input)
	return ConvertToAPIModel(state), nil
}

// ValidateTime implements the OpenAPI endpoint for validating a time input.
func (s *ApiControllerImpl) ValidateTime(req *api.ApiTimeInput) (*api.ApiValidationResult, error) {
	input := TimeInput{
		Hour:   int(req.Hour),
		Minute: int(req.Minute),
		Second: int(req.Second),
	}
	err := ValidateTimeInput(input)
	if err != nil {
		return &api.ApiValidationResult{
			Valid:        false,
			ErrorMessage: err.Error(),
		}, nil
	}
	return &api.ApiValidationResult{
		Valid:        true,
		ErrorMessage: "",
	}, nil
}