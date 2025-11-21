module Api exposing
    ( Request
    , request
    , send
    , sendWithCustomError
    , sendWithCustomExpect
    , task
    , map
    , withBasePath
    , withTimeout
    , withTracker
    , withBearerToken
    , withHeader
    , withHeaders
    )

import Http
import Json.Decode
import Task exposing (Task)
import Api.Api as Core


type alias Request a =
    Core.Request a


request : String -> String -> List ( String, String ) -> List ( String, Maybe String ) -> List ( String, Maybe String ) -> Maybe Http.Body -> Json.Decode.Decoder a -> Request a
request =
    Core.request


send : (Result Http.Error a -> msg) -> Request a -> Cmd msg
send =
    Core.send


sendWithCustomError : (Http.Error -> e) -> (Result e a -> msg) -> Request a -> Cmd msg
sendWithCustomError =
    Core.sendWithCustomError


sendWithCustomExpect : (Json.Decode.Decoder a -> Http.Expect msg) -> Request a -> Cmd msg
sendWithCustomExpect =
    Core.sendWithCustomExpect


task : Request a -> Task Http.Error a
task =
    Core.task


map : (a -> b) -> Request a -> Request b
map =
    Core.map


withBasePath : String -> Request a -> Request a
withBasePath =
    Core.withBasePath


withTimeout : Float -> Request a -> Request a
withTimeout =
    Core.withTimeout


withTracker : String -> Request a -> Request a
withTracker =
    Core.withTracker


withBearerToken : String -> Request a -> Request a
withBearerToken =
    Core.withBearerToken


withHeader : String -> String -> Request a -> Request a
withHeader =
    Core.withHeader


withHeaders : List ( String, String ) -> Request a -> Request a
withHeaders =
    Core.withHeaders
