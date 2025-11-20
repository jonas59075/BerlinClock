module BerlinClock.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import BerlinClock.Model exposing (Model)

view : Model -> Html msg
view model =
    div [ class "berlin-clock", style "font-family" "sans-serif" ]
        [ secondsLamp model.seconds
        , hourRow5 (model.hours // 5)
        , hourRow1 (model.hours % 5)
        , minuteRow5 (model.minutes // 5)
        , minuteRow1 (model.minutes % 5)
        ]

secondsLamp : Int -> Html msg
secondsLamp s =
    let
        isOn =
            (s % 2) == 0
    in
    lamp (if isOn then "yellow" else "off")

hourRow5 : Int -> Html msg
hourRow5 n =
    row (List.map (\i -> if i <= n then "red" else "off") (List.range 1 4))

hourRow1 : Int -> Html msg
hourRow1 n =
    row (List.map (\i -> if i <= n then "red" else "off") (List.range 1 4))

minuteRow5 : Int -> Html msg
minuteRow5 n =
    row
        (List.map
            (\i ->
                if i <= n then
                    if (i % 3) == 0 then
                        "red"
                    else
                        "yellow"
                else
                    "off"
            )
            (List.range 1 11)
        )

minuteRow1 : Int -> Html msg
minuteRow1 n =
    row (List.map (\i -> if i <= n then "yellow" else "off") (List.range 1 4))

row : List String -> Html msg
row lamps =
    div [ class "row" ]
        (List.map lamp lamps)

lamp : String -> Html msg
lamp color =
    let
        css =
            case color of
                "red" ->
                    [ style "background" "#d00" ]
                "yellow" ->
                    [ style "background" "#dd0" ]
                "off" ->
                    [ style "background" "#333" ]
                _ ->
                    [ style "background" "#333" ]
    in
    div
        ([ style "width" "30px"
         , style "height" "30px"
         , style "margin" "3px"
         , style "border-radius" "4px"
         , style "display" "inline-block"
         ]
            ++ css
        )
        []
