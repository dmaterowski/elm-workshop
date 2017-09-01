module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String


all : Test
all =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Addition" <|
                \() ->
                    { test1 = "test1", test2 = 2 }
                        |> \v ->
                            v.test1
                        |> Expect.equal "test1" 
            , test "Test" <|
                \() -> 
                    funkcja 1 1
                    |> Expect.equal 2
            ]
        ]

funkcja n t = 
    n + t
