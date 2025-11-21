module Main exposing
    ( BerlinClockDisplay
    , LampColor(..)
    , clockDisplayFromState
    , formatTime
    , main
    )

import Api.Api
import Api.Data
import Api.Request.Default
import Browser
import Html exposing (Html, div, h1, p, span, text)
import Html.Attributes exposing (style)
import Http
import String
import Time


-- MODEL


type alias Model =
    { status : Status
    , time : Maybe Api.Data.TimeResponse
    , clock : Maybe Api.Data.BerlinClockState
    }


type Status
    = Loading
    | Loaded
    | Error String


type alias BerlinClockDisplay =
    { secondsLamp : LampColor
    , fiveHoursRow : List LampColor
    , singleHoursRow : List LampColor
    , fiveMinutesRow : List LampColor
    , singleMinutesRow : List LampColor
    }


type LampColor
    = Red
    | Yellow
    | Off


type Msg
    = Tick
    | GotTime (Result Http.Error Api.Data.TimeResponse)
    | GotClock (Result Http.Error Api.Data.BerlinClockState)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, initialCmds )
        , update = update
        , subscriptions = \_ -> Time.every 1000 (always Tick)
        , view = view
        }


initialModel : Model
initialModel =
    { status = Loading
    , time = Nothing
    , clock = Nothing
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch [ requestTime, requestClock ]


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            ( model, Cmd.batch [ requestTime, requestClock ] )

        GotTime result ->
            case result of
                Ok timeResponse ->
                    let
                        updated =
                            { model | time = Just timeResponse }
                    in
                    ( { updated | status = deriveStatus updated }, Cmd.none )

                Err err ->
                    ( { model | status = Error (httpErrorToText err) }, Cmd.none )

        GotClock result ->
            case result of
                Ok clockResponse ->
                    let
                        updated =
                            { model | clock = Just clockResponse }
                    in
                    ( { updated | status = deriveStatus updated }, Cmd.none )

                Err err ->
                    ( { model | status = Error (httpErrorToText err) }, Cmd.none )


requestTime : Cmd Msg
requestTime =
    Api.Api.send GotTime Api.Request.Default.timeGet


requestClock : Cmd Msg
requestClock =
    Api.Api.send GotClock Api.Request.Default.berlinClockGet


deriveStatus : Model -> Status
deriveStatus model =
    if hasTime model && hasClock model then
        Loaded

    else
        case model.status of
            Error message ->
                Error message

            _ ->
                Loading


hasTime : Model -> Bool
hasTime model =
    Maybe.withDefault False (Maybe.map (always True) model.time)


hasClock : Model -> Bool
hasClock model =
    Maybe.withDefault False (Maybe.map (always True) model.clock)


httpErrorToText : Http.Error -> String
httpErrorToText httpError =
    case httpError of
        Http.BadUrl badUrl ->
            "Bad URL: " ++ badUrl

        Http.Timeout ->
            "Timeout bei der Abfrage"

        Http.NetworkError ->
            "Netzwerkfehler"

        Http.BadStatus statusCode ->
            "HTTP-Fehler " ++ String.fromInt statusCode

        Http.BadBody message ->
            "Antwort konnte nicht gelesen werden: " ++ message


-- VIEW


view : Model -> Html Msg
view model =
    let
        display =
            clockDisplayFromState model.clock

        timeText =
            formatTime model.time
    in
    div pageStyle
        [ div containerStyle
            [ h1 titleStyle [ text "Berliner Uhr" ]
            , p subtitleStyle [ text "Automatisch aktualisierte Visualisierung der Berliner Uhr." ]
            , statusBanner model.status timeText
            , clockView display
            ]
        ]


clockView : BerlinClockDisplay -> Html Msg
clockView display =
    div clockStyle
        [ singleLamp "Sekunden" display.secondsLamp
        , lampRow "5h" display.fiveHoursRow
        , lampRow "1h" display.singleHoursRow
        , lampRow "5m" display.fiveMinutesRow
        , lampRow "1m" display.singleMinutesRow
        ]


statusBanner : Status -> String -> Html Msg
statusBanner status timeText =
    case status of
        Loading ->
            div infoBannerStyle [ text "Lade aktuelle Uhrzeit..." ]

        Loaded ->
            div successBannerStyle [ text ("Aktuelle Zeit: " ++ timeText) ]

        Error message ->
            div errorBannerStyle [ text ("Fehler beim Laden: " ++ message) ]


clockDisplayFromState : Maybe Api.Data.BerlinClockState -> BerlinClockDisplay
clockDisplayFromState maybeState =
    let
        state =
            Maybe.withDefault
                { secondsLamp = Nothing
                , fiveHoursRow = Nothing
                , singleHoursRow = Nothing
                , fiveMinutesRow = Nothing
                , singleMinutesRow = Nothing
                }
                maybeState
    in
    { secondsLamp = secondsLampFromState state.secondsLamp
    , fiveHoursRow = normalizeRow 4 fiveHoursLamp state.fiveHoursRow
    , singleHoursRow = normalizeRow 4 singleHoursLamp state.singleHoursRow
    , fiveMinutesRow = normalizeRow 11 fiveMinutesLamp state.fiveMinutesRow
    , singleMinutesRow = normalizeRow 4 singleMinutesLamp state.singleMinutesRow
    }


formatTime : Maybe Api.Data.TimeResponse -> String
formatTime maybeTime =
    case maybeTime of
        Nothing ->
            "--:--:--"

        Just timeResponse ->
            let
                formatPart maybeValue =
                    maybeValue
                        |> Maybe.map twoDigits
                        |> Maybe.withDefault "--"
            in
            String.join ":"
                [ formatPart timeResponse.hour
                , formatPart timeResponse.minute
                , formatPart timeResponse.second
                ]


twoDigits : Int -> String
twoDigits value =
    value
        |> String.fromInt
        |> String.padLeft 2 '0'


normalizeRow : Int -> (a -> LampColor) -> Maybe (List a) -> List LampColor
normalizeRow desiredLength toColor maybeRow =
    let
        converted =
            maybeRow
                |> Maybe.withDefault []
                |> List.map toColor
                |> List.take desiredLength

        missing =
            max 0 (desiredLength - List.length converted)
    in
    converted ++ List.repeat missing Off


secondsLampFromState : Maybe Api.Data.BerlinClockStateSecondsLamp -> LampColor
secondsLampFromState maybeLamp =
    case maybeLamp of
        Just Api.Data.BerlinClockStateSecondsLampY ->
            Yellow

        _ ->
            Off


fiveHoursLamp : Api.Data.BerlinClockStateFiveHoursRow -> LampColor
fiveHoursLamp lampState =
    case lampState of
        Api.Data.BerlinClockStateFiveHoursRowR ->
            Red

        Api.Data.BerlinClockStateFiveHoursRowO ->
            Off


singleHoursLamp : Api.Data.BerlinClockStateSingleHoursRow -> LampColor
singleHoursLamp lampState =
    case lampState of
        Api.Data.BerlinClockStateSingleHoursRowR ->
            Red

        Api.Data.BerlinClockStateSingleHoursRowO ->
            Off


fiveMinutesLamp : Api.Data.BerlinClockStateFiveMinutesRow -> LampColor
fiveMinutesLamp lampState =
    case lampState of
        Api.Data.BerlinClockStateFiveMinutesRowY ->
            Yellow

        Api.Data.BerlinClockStateFiveMinutesRowR ->
            Red

        Api.Data.BerlinClockStateFiveMinutesRowO ->
            Off


singleMinutesLamp : Api.Data.BerlinClockStateSingleMinutesRow -> LampColor
singleMinutesLamp lampState =
    case lampState of
        Api.Data.BerlinClockStateSingleMinutesRowY ->
            Yellow

        Api.Data.BerlinClockStateSingleMinutesRowO ->
            Off


-- VIEW HELPERS


singleLamp : String -> LampColor -> Html Msg
singleLamp label lampColor =
    div rowWrapperStyle
        [ span rowLabelStyle [ text label ]
        , div [ style "display" "flex" ] [ lamp 52 52 lampColor ]
        ]


lampRow : String -> List LampColor -> Html Msg
lampRow label lamps =
    div rowWrapperStyle
        [ span rowLabelStyle [ text label ]
        , div [ style "display" "flex", style "gap" "8px" ] (List.map (lamp 44 32) lamps)
        ]


lamp : Int -> Int -> LampColor -> Html Msg
lamp width height color =
    let
        colorCode =
            case color of
                Red ->
                    "#FF4444"

                Yellow ->
                    "#FFCC00"

                Off ->
                    "#333333"

        borderColor =
            case color of
                Off ->
                    "#555"

                _ ->
                    colorCode
    in
    div
        [ style "width" (String.fromInt width ++ "px")
        , style "height" (String.fromInt height ++ "px")
        , style "background-color" colorCode
        , style "border" ("2px solid " ++ borderColor)
        , style "border-radius" "8px"
        , style "box-shadow" "0 2px 6px rgba(0, 0, 0, 0.45)"
        ]
        []


pageStyle : List (Html.Attribute msg)
pageStyle =
    [ style "min-height" "100vh"
    , style "margin" "0"
    , style "padding" "0"
    , style "display" "flex"
    , style "justify-content" "center"
    , style "align-items" "center"
    , style "background" "#0f172a"
    , style "color" "#f8fafc"
    , style "font-family" "Inter, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
    ]


containerStyle : List (Html.Attribute msg)
containerStyle =
    [ style "width" "min(960px, 90vw)"
    , style "background" "rgba(15, 23, 42, 0.7)"
    , style "border" "1px solid rgba(255, 255, 255, 0.08)"
    , style "border-radius" "16px"
    , style "padding" "32px"
    , style "box-shadow" "0 20px 45px rgba(0, 0, 0, 0.35)"
    ]


titleStyle : List (Html.Attribute msg)
    

titleStyle =
    [ style "margin" "0 0 8px 0"
    , style "font-size" "32px"
    ]


subtitleStyle : List (Html.Attribute msg)
subtitleStyle =
    [ style "margin" "0 0 24px 0"
    , style "color" "#cbd5e1"
    ]


clockStyle : List (Html.Attribute msg)
clockStyle =
    [ style "display" "flex"
    , style "flex-direction" "column"
    , style "gap" "12px"
    , style "padding" "20px"
    , style "background" "rgba(255, 255, 255, 0.03)"
    , style "border-radius" "12px"
    , style "border" "1px solid rgba(255, 255, 255, 0.04)"
    ]


rowWrapperStyle : List (Html.Attribute msg)
rowWrapperStyle =
    [ style "display" "flex"
    , style "align-items" "center"
    , style "gap" "12px"
    ]


rowLabelStyle : List (Html.Attribute msg)
rowLabelStyle =
    [ style "width" "44px"
    , style "font-weight" "600"
    , style "color" "#cbd5e1"
    ]


infoBannerStyle : List (Html.Attribute msg)
infoBannerStyle =
    [ style "background" "rgba(59, 130, 246, 0.12)"
    , style "border" "1px solid rgba(59, 130, 246, 0.35)"
    , style "color" "#bfdbfe"
    , style "padding" "12px 16px"
    , style "border-radius" "10px"
    , style "margin-bottom" "18px"
    ]


successBannerStyle : List (Html.Attribute msg)
successBannerStyle =
    [ style "background" "rgba(74, 222, 128, 0.12)"
    , style "border" "1px solid rgba(74, 222, 128, 0.4)"
    , style "color" "#bbf7d0"
    , style "padding" "12px 16px"
    , style "border-radius" "10px"
    , style "margin-bottom" "18px"
    ]


errorBannerStyle : List (Html.Attribute msg)
errorBannerStyle =
    [ style "background" "rgba(239, 68, 68, 0.12)"
    , style "border" "1px solid rgba(239, 68, 68, 0.45)"
    , style "color" "#fecdd3"
    , style "padding" "12px 16px"
    , style "border-radius" "10px"
    , style "margin-bottom" "18px"
    ]

