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
            [ headerSection
            , statusBanner model.status timeText
            , clockView display
            , digitalTimeView timeText
            ]
        ]


clockView : BerlinClockDisplay -> Html Msg
clockView display =
    div clockCardStyle
        [ div clockHeaderStyle
            [ h1 clockTitleStyle [ text "Berlin-Uhr" ]
            , p clockSubtitleStyle [ text "Legendäres Wahrzeichen am Ku'damm, inspiriert in modernem Glühen." ]
            ]
        , div clockStyle
            [ singleLamp "Sekunden" display.secondsLamp
            , lampRow "5 Stunden" 96 46 10 display.fiveHoursRow
            , lampRow "1 Stunde" 96 46 10 display.singleHoursRow
            , lampRow "5 Minuten" 64 34 8 display.fiveMinutesRow
            , lampRow "1 Minute" 64 34 8 display.singleMinutesRow
            ]
        ]


digitalTimeView : String -> Html Msg
digitalTimeView timeText =
    div digitalTimeStyle
        [ div digitalLabelStyle [ text "24h-Anzeige" ]
        , div digitalValueStyle [ text (timeText ++ " Uhr") ]
        , p digitalHintStyle [ text "Die Berliner Uhr zeigt Stunden und Minuten in Farbreihen. Die Zeitanzeige darunter liefert das exakte 24-Stunden-Format." ]
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


headerSection : Html Msg
headerSection =
    div headerStyle
        [ div headerBadgeStyle [ text "Live aus Berlin" ]
        , h1 titleStyle [ text "Berliner Uhr" ]
        , p subtitleStyle [ text "Legendäres Design, neu interpretiert: Die farbigen Lampen der Berlin-Uhr werden jede Sekunde automatisch aktualisiert." ]
        ]


singleLamp : String -> LampColor -> Html Msg
singleLamp label lampColor =
    div rowWrapperStyle
        [ span rowLabelStyle [ text label ]
        , div [ style "display" "flex" ] [ lamp 72 72 "50%" lampColor ]
        ]


lampRow : String -> Int -> Int -> Int -> List LampColor -> Html Msg
lampRow label lampWidth lampHeight gap lamps =
    div rowWrapperStyle
        [ span rowLabelStyle [ text label ]
        , div [ style "display" "flex", style "gap" (String.fromInt gap ++ "px") ] (List.map (lamp lampWidth lampHeight "14px") lamps)
        ]


lamp : Int -> Int -> String -> LampColor -> Html Msg
lamp width height radius color =
    let
        colorCode =
            case color of
                Red ->
                    "#e50914"

                Yellow ->
                    "#ffcc00"

                Off ->
                    "#111827"

        borderColor =
            case color of
                Off ->
                    "#1f2937"

                _ ->
                    colorCode

        glow =
            case color of
                Red ->
                    "0 0 18px rgba(229, 9, 20, 0.65), 0 0 42px rgba(229, 9, 20, 0.35)"

                Yellow ->
                    "0 0 18px rgba(255, 204, 0, 0.65), 0 0 42px rgba(255, 204, 0, 0.35)"

                Off ->
                    "0 0 0 rgba(0,0,0,0)"
    in
    div
        [ style "width" (String.fromInt width ++ "px")
        , style "height" (String.fromInt height ++ "px")
        , style "background-color" colorCode
        , style "border" ("2px solid " ++ borderColor)
        , style "border-radius" radius
        , style "box-shadow" glow
        , style "transition" "transform 120ms ease, box-shadow 120ms ease"
        ]
        []


pageStyle : List (Html.Attribute msg)
pageStyle =
    [ style "min-height" "100vh"
    , style "margin" "0"
    , style "padding" "32px 18px"
    , style "display" "flex"
    , style "justify-content" "center"
    , style "align-items" "center"
    , style "background" "radial-gradient(circle at 20% 20%, rgba(255, 204, 0, 0.08), transparent 35%), radial-gradient(circle at 80% 0%, rgba(229, 9, 20, 0.12), transparent 35%), linear-gradient(135deg, #0b1021 0%, #0f172a 40%, #0b1021 100%)"
    , style "color" "#f8fafc"
    , style "font-family" "Inter, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
    ]


containerStyle : List (Html.Attribute msg)
containerStyle =
    [ style "width" "min(1080px, 96vw)"
    , style "background" "linear-gradient(140deg, rgba(15, 23, 42, 0.8), rgba(15, 23, 42, 0.55))"
    , style "border" "1px solid rgba(255, 255, 255, 0.08)"
    , style "border-radius" "20px"
    , style "padding" "42px 38px"
    , style "box-shadow" "0 20px 60px rgba(0, 0, 0, 0.45)"
    , style "backdrop-filter" "blur(8px)"
    ]


headerStyle : List (Html.Attribute msg)
headerStyle =
    [ style "display" "flex"
    , style "flex-direction" "column"
    , style "gap" "10px"
    , style "margin-bottom" "18px"
    ]


headerBadgeStyle : List (Html.Attribute msg)
headerBadgeStyle =
    [ style "display" "inline-flex"
    , style "align-items" "center"
    , style "gap" "8px"
    , style "padding" "8px 12px"
    , style "border-radius" "999px"
    , style "background" "rgba(255, 204, 0, 0.12)"
    , style "color" "#facc15"
    , style "font-weight" "700"
    , style "font-size" "13px"
    ]


titleStyle : List (Html.Attribute msg)
titleStyle =
    [ style "margin" "0"
    , style "font-size" "40px"
    , style "letter-spacing" "-0.03em"
    ]


subtitleStyle : List (Html.Attribute msg)
subtitleStyle =
    [ style "margin" "0"
    , style "color" "#cbd5e1"
    , style "line-height" "1.5"
    ]


clockCardStyle : List (Html.Attribute msg)
clockCardStyle =
    [ style "margin-top" "28px"
    , style "background" "linear-gradient(180deg, rgba(255, 255, 255, 0.03), rgba(255, 255, 255, 0.01))"
    , style "border" "1px solid rgba(255, 255, 255, 0.06)"
    , style "border-radius" "16px"
    , style "padding" "18px"
    , style "box-shadow" "0 18px 46px rgba(0, 0, 0, 0.35)"
    ]


clockHeaderStyle : List (Html.Attribute msg)
clockHeaderStyle =
    [ style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "space-between"
    , style "gap" "12px"
    , style "margin-bottom" "12px"
    ]


clockTitleStyle : List (Html.Attribute msg)
clockTitleStyle =
    [ style "margin" "0"
    , style "font-size" "28px"
    ]


clockSubtitleStyle : List (Html.Attribute msg)
clockSubtitleStyle =
    [ style "margin" "0"
    , style "color" "#9ca3af"
    , style "font-size" "15px"
    ]


clockStyle : List (Html.Attribute msg)
clockStyle =
    [ style "display" "flex"
    , style "flex-direction" "column"
    , style "align-items" "center"
    , style "gap" "14px"
    , style "padding" "20px"
    , style "background" "radial-gradient(circle at 50% 0%, rgba(255, 204, 0, 0.1), rgba(229, 9, 20, 0.12) 38%, transparent 52%), rgba(10, 12, 25, 0.8)"
    , style "border-radius" "12px"
    , style "border" "1px solid rgba(255, 255, 255, 0.06)"
    ]


rowWrapperStyle : List (Html.Attribute msg)
rowWrapperStyle =
    [ style "display" "flex"
    , style "align-items" "center"
    , style "gap" "14px"
    ]


rowLabelStyle : List (Html.Attribute msg)
rowLabelStyle =
    [ style "width" "110px"
    , style "font-weight" "700"
    , style "letter-spacing" "0.01em"
    , style "color" "#e2e8f0"
    ]


digitalTimeStyle : List (Html.Attribute msg)
digitalTimeStyle =
    [ style "margin-top" "30px"
    , style "padding" "18px 20px"
    , style "border-radius" "14px"
    , style "background" "linear-gradient(145deg, rgba(16, 185, 129, 0.16), rgba(15, 23, 42, 0.6))"
    , style "border" "1px solid rgba(16, 185, 129, 0.35)"
    , style "box-shadow" "0 16px 28px rgba(16, 185, 129, 0.15)"
    , style "display" "flex"
    , style "flex-direction" "column"
    , style "gap" "6px"
    ]


digitalLabelStyle : List (Html.Attribute msg)
digitalLabelStyle =
    [ style "font-size" "13px"
    , style "text-transform" "uppercase"
    , style "letter-spacing" "0.08em"
    , style "color" "#a5f3fc"
    , style "font-weight" "700"
    ]


digitalValueStyle : List (Html.Attribute msg)
digitalValueStyle =
    [ style "font-size" "34px"
    , style "font-variant-numeric" "tabular-nums"
    , style "font-weight" "800"
    ]


digitalHintStyle : List (Html.Attribute msg)
digitalHintStyle =
    [ style "margin" "0"
    , style "color" "#cbd5e1"
    , style "line-height" "1.4"
    ]


infoBannerStyle : List (Html.Attribute msg)
infoBannerStyle =
    [ style "background" "rgba(59, 130, 246, 0.12)"
    , style "border" "1px solid rgba(59, 130, 246, 0.35)"
    , style "color" "#bfdbfe"
    , style "padding" "12px 16px"
    , style "border-radius" "12px"
    , style "margin-bottom" "14px"
    ]


successBannerStyle : List (Html.Attribute msg)
successBannerStyle =
    [ style "background" "rgba(74, 222, 128, 0.12)"
    , style "border" "1px solid rgba(74, 222, 128, 0.4)"
    , style "color" "#bbf7d0"
    , style "padding" "12px 16px"
    , style "border-radius" "12px"
    , style "margin-bottom" "14px"
    ]


errorBannerStyle : List (Html.Attribute msg)
errorBannerStyle =
    [ style "background" "rgba(239, 68, 68, 0.12)"
    , style "border" "1px solid rgba(239, 68, 68, 0.45)"
    , style "color" "#fecdd3"
    , style "padding" "12px 16px"
    , style "border-radius" "12px"
    , style "margin-bottom" "14px"
    ]

