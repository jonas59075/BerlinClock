module BerlinClock.Model exposing (Model, init)

type alias Model =
    { hours : Int
    , minutes : Int
    , seconds : Int
    }

init : Model
init =
    { hours = 12
    , minutes = 34
    , seconds = 56
    }
