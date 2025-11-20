module BerlinClock.Model exposing (Model, init)

type alias Model =
    { hours : Int
    , minutes : Int
    , seconds : Int
    , error : Maybe String
    }

init : Model
init =
    { hours = 0
    , minutes = 0
    , seconds = 0
    , error = Nothing
    }
