package berlinclock

import (
	"fmt"

	api "backend/gen/api/go"
)

// TimeInput represents the domain time input model.
type TimeInput struct {
	Hour   int
	Minute int
	Second int
}

// BerlinClockState represents the domain Berlin Clock state model.
type BerlinClockState struct {
	SecondsLamp   string
	FiveHourRow   string
	OneHourRow    string
	FiveMinuteRow string
	OneMinuteRow  string
}

// ValidateTimeInput validates the given TimeInput according to domain invariants.
func ValidateTimeInput(input TimeInput) (ok bool, errMsg string) {
	if input.Hour < 0 || input.Hour > 23 {
		return false, "hour must be between 0 and 23"
	}
	if input.Minute < 0 || input.Minute > 59 {
		return false, "minute must be between 0 and 59"
	}
	if input.Second < 0 || input.Second > 59 {
		return false, "second must be between 0 and 59"
	}
	return true, ""
}

// ComputeBerlinClockState computes the BerlinClockState for a given valid TimeInput.
func ComputeBerlinClockState(input TimeInput) BerlinClockState {
	// secondsLamp
	var secondsLamp string
	if input.Second%2 == 0 {
		secondsLamp = "X"
	} else {
		secondsLamp = "O"
	}

	// fiveHourRow
	lit5 := input.Hour / 5
	fiveHourRow := ""
	for i := 0; i < 4; i++ {
		if i < lit5 {
			fiveHourRow += "X"
		} else {
			fiveHourRow += "O"
		}
	}

	// oneHourRow
	lit1 := input.Hour % 5
	oneHourRow := ""
	for i := 0; i < 4; i++ {
		if i < lit1 {
			oneHourRow += "X"
		} else {
			oneHourRow += "O"
		}
	}

	// fiveMinuteRow
	lit5m := input.Minute / 5
	fiveMinuteRow := ""
	for i := 0; i < 11; i++ {
		if i < lit5m {
			if (i+1)%3 == 0 {
				fiveMinuteRow += "R"
			} else {
				fiveMinuteRow += "Y"
			}
		} else {
			fiveMinuteRow += "O"
		}
	}

	// oneMinuteRow
	lit1m := input.Minute % 5
	oneMinuteRow := ""
	for i := 0; i < 4; i++ {
		if i < lit1m {
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

// ConvertToAPIModel converts a domain BerlinClockState to the OpenAPI ApiBerlinClockState.
func ConvertToAPIModel(state BerlinClockState) api.ApiBerlinClockState {
	return api.ApiBerlinClockState{
		SecondsLamp:   state.SecondsLamp,
		FiveHourRow:   state.FiveHourRow,
		OneHourRow:    state.OneHourRow,
		FiveMinuteRow: state.FiveMinuteRow,
		OneMinuteRow:  state.OneMinuteRow,
	}
}

// ApiControllerImpl implements the OpenAPI ApiController interface.
type ApiControllerImpl struct{}

// NewApiControllerImpl creates a new ApiControllerImpl.
func NewApiControllerImpl() *ApiControllerImpl {
	return &ApiControllerImpl{}
}

// BerlinClockState implements the OpenAPI endpoint for computing the Berlin Clock state.
func (s *ApiControllerImpl) BerlinClockState(req api.ApiBerlinClockStateRequest) (api.ApiBerlinClockState, error) {
	input := TimeInput{
		Hour:   int(req.Hour),
		Minute: int(req.Minute),
		Second: int(req.Second),
	}
	if ok, errMsg := ValidateTimeInput(input); !ok {
		return api.ApiBerlinClockState{}, fmt.Errorf("invalid input: %s", errMsg)
	}
	state := ComputeBerlinClockState(input)
	return ConvertToAPIModel(state), nil
}

// BerlinClockValidateTime implements the OpenAPI endpoint for validating time input.
func (s *ApiControllerImpl) BerlinClockValidateTime(req api.ApiBerlinClockValidateTimeRequest) (api.ApiBerlinClockValidateTimeResponse, error) {
	input := TimeInput{
		Hour:   int(req.Hour),
		Minute: int(req.Minute),
		Second: int(req.Second),
	}
	ok, errMsg := ValidateTimeInput(input)
	if ok {
		return api.ApiBerlinClockValidateTimeResponse{
			Valid:       true,
			ErrorMessage: "",
		}, nil
	}
	return api.ApiBerlinClockValidateTimeResponse{
		Valid:       false,
		ErrorMessage: errMsg,
	}, nil
}
