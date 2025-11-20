module Smoke exposing (tests)

import Expect exposing (equal)
import Test exposing (..)

tests : Test
tests =
    test "Elm Test läuft" <| \_ -> Expect.equal 1 1
