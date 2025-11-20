package backend

import "time"

type BerlinClockState struct {
	Seconds       string
	HoursTop      string
	HoursBottom   string
	MinutesTop    string
	MinutesBottom string
}

func ConvertToBerlinClock(t time.Time) BerlinClockState {
	sec := t.Second()
	min := t.Minute()
	hour := t.Hour()
	return BerlinClockState{
		Seconds:       calculateSeconds(sec),
		HoursTop:      calculateHoursTop(hour),
		HoursBottom:   calculateHoursBottom(hour),
		MinutesTop:    calculateMinutesTop(min),
		MinutesBottom: calculateMinutesBottom(min),
	}
}

func calculateSeconds(sec int) string {
	if sec%2 == 0 {
		return "Y"
	}
	return "O"
}

func calculateHoursTop(hour int) string {
	onLamps := hour / 5
	result := make([]byte, 4)
	for i := 0; i < 4; i++ {
		if i < onLamps {
			result[i] = 'R'
		} else {
			result[i] = 'O'
		}
	}
	return string(result)
}

func calculateHoursBottom(hour int) string {
	onLamps := hour % 5
	result := make([]byte, 4)
	for i := 0; i < 4; i++ {
		if i < onLamps {
			result[i] = 'R'
		} else {
			result[i] = 'O'
		}
	}
	return string(result)
}

func calculateMinutesTop(min int) string {
	onLamps := min / 5
	result := make([]byte, 11)
	for i := 0; i < 11; i++ {
		if i < onLamps {
			// Lamps at positions 3, 6, 9 (1-based) are red for quarters
			if (i+1)%3 == 0 {
				result[i] = 'R'
			} else {
				result[i] = 'Y'
			}
		} else {
			result[i] = 'O'
		}
	}
	return string(result)
}

func calculateMinutesBottom(min int) string {
	onLamps := min % 5
	result := make([]byte, 4)
	for i := 0; i < 4; i++ {
		if i < onLamps {
			result[i] = 'Y'
		} else {
			result[i] = 'O'
		}
	}
	return string(result)
}
