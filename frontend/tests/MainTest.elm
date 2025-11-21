module MainTest exposing (suite)

import Api.Data
import Expect
import Main exposing (LampColor(..), clockDisplayFromState, formatTime)
import Test exposing (..)


suite : Test
suite =
    describe "Berlin Clock helpers"
        [ test "fills missing lamp rows with off lamps" <|
            \_ ->
                let
                    display =
                        clockDisplayFromState Nothing
                in
                Expect.all
                    [ \state -> Expect.equal Off state.secondsLamp
                    , \state -> Expect.equal 4 (List.length state.fiveHoursRow)
                    , \state -> Expect.equal 4 (List.length state.singleHoursRow)
                    , \state -> Expect.equal 11 (List.length state.fiveMinutesRow)
                    , \state -> Expect.equal 4 (List.length state.singleMinutesRow)
                    , \state -> Expect.equal True (List.all ((==) Off) state.fiveHoursRow)
                    , \state -> Expect.equal True (List.all ((==) Off) state.singleHoursRow)
                    , \state -> Expect.equal True (List.all ((==) Off) state.fiveMinutesRow)
                    , \state -> Expect.equal True (List.all ((==) Off) state.singleMinutesRow)
                    ]
                    display
        , test "maps API state variants to lamp colors" <|
            \_ ->
                let
                    state : Api.Data.BerlinClockState
                    state =
                        { secondsLamp = Just Api.Data.BerlinClockStateSecondsLampY
                        , fiveHoursRow = Just
                            [ Api.Data.BerlinClockStateFiveHoursRowR
                            , Api.Data.BerlinClockStateFiveHoursRowO
                            , Api.Data.BerlinClockStateFiveHoursRowR
                            , Api.Data.BerlinClockStateFiveHoursRowO
                            ]
                        , singleHoursRow = Just
                            [ Api.Data.BerlinClockStateSingleHoursRowR
                            , Api.Data.BerlinClockStateSingleHoursRowO
                            , Api.Data.BerlinClockStateSingleHoursRowO
                            , Api.Data.BerlinClockStateSingleHoursRowR
                            ]
                        , fiveMinutesRow = Just
                            [ Api.Data.BerlinClockStateFiveMinutesRowY
                            , Api.Data.BerlinClockStateFiveMinutesRowR
                            , Api.Data.BerlinClockStateFiveMinutesRowO
                            , Api.Data.BerlinClockStateFiveMinutesRowY
                            , Api.Data.BerlinClockStateFiveMinutesRowR
                            , Api.Data.BerlinClockStateFiveMinutesRowO
                            , Api.Data.BerlinClockStateFiveMinutesRowY
                            , Api.Data.BerlinClockStateFiveMinutesRowO
                            , Api.Data.BerlinClockStateFiveMinutesRowR
                            , Api.Data.BerlinClockStateFiveMinutesRowO
                            , Api.Data.BerlinClockStateFiveMinutesRowY
                            ]
                        , singleMinutesRow = Just
                            [ Api.Data.BerlinClockStateSingleMinutesRowY
                            , Api.Data.BerlinClockStateSingleMinutesRowO
                            , Api.Data.BerlinClockStateSingleMinutesRowY
                            , Api.Data.BerlinClockStateSingleMinutesRowO
                            ]
                        }

                    display =
                        clockDisplayFromState (Just state)
                in
                Expect.all
                    [ \viewState -> Expect.equal Yellow viewState.secondsLamp
                    , \viewState -> Expect.equal [ Red, Off, Red, Off ] viewState.fiveHoursRow
                    , \viewState -> Expect.equal [ Red, Off, Off, Red ] viewState.singleHoursRow
                    , \viewState ->
                        Expect.equal
                            [ Yellow
                            , Red
                            , Off
                            , Yellow
                            , Red
                            , Off
                            , Yellow
                            , Off
                            , Red
                            , Off
                            , Yellow
                            ]
                            viewState.fiveMinutesRow
                    , \viewState -> Expect.equal [ Yellow, Off, Yellow, Off ] viewState.singleMinutesRow
                    ]
                    display
        , test "formats incomplete time values with placeholders" <|
            \_ ->
                let
                    timeResponse =
                        { hour = Just 7
                        , minute = Nothing
                        , second = Just 3
                        }
                in
                Expect.equal "07:--:03" (formatTime (Just timeResponse))
        ]
