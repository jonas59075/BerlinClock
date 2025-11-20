module BerlinClock.Update exposing (Msg, update)

import BerlinClock.Model exposing (Model)

type Msg
    = Tick

update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick ->
            model
