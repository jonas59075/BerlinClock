module Main exposing (main)

import Browser
import Html exposing (Html)
import BerlinClock.Model as Model
import BerlinClock.Update as Update
import BerlinClock.View as View


main : Program () Model.Model Update.Msg
main =
    Browser.element
        { init = \_ -> ( Model.init, Cmd.none )
        , update = Update.update
        , subscriptions = Update.subscriptions
        , view = View.view
        }
