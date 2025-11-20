module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (class)
import BerlinClock.Model as Model
import BerlinClock.Update as Update
import BerlinClock.View as View

main : Program () Model.Model Update.Msg
main =
    Browser.sandbox
        { init = Model.init
        , update = Update.update
        , view = View.view
        }
