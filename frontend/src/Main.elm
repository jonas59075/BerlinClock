module Main exposing (main)

import Browser
import Html exposing (Html, div, text)

main : Program () () Msg
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = \_ -> view
        }

view : Html Msg
view =
    div [] [ text "Berlin Clock – Main.elm OK" ]

type Msg
    = NoOp
