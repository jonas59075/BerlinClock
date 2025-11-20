module BerlinClock.Update exposing (Msg, update, subscriptions)

import BerlinClock.Model exposing (Model)
import Http
import Json.Decode as D
import Time


type Msg
    = Tick Time.Posix
    | GotTime (Result Http.Error Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model, getTime )

        GotTime (Ok newModel) ->
            ( newModel, Cmd.none )

        GotTime (Err _) ->
            ( { model | error = Just "API error" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


getTime : Cmd Msg
getTime =
    Http.get
        { url = "/clock/current"
        , expect = Http.expectJson GotTime decoder
        }


decoder : D.Decoder Model
decoder =
    D.map3
        (\h m s -> { hours = h, minutes = m, seconds = s, error = Nothing })
        (D.field "hours" D.int)
        (D.field "minutes" D.int)
        (D.field "seconds" D.int)
