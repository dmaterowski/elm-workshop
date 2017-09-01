module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Ex3 exposing (..)


all : Test
all =
    describe "Ex3 test suite"
        [ describe "List processor should"
            [ test "add square sum on beginning" <|
                \() ->
                    Expect.equal (processList [1, 2, 3]) [36, 1, 2, 3]
            -- , test "return [ -1 ] if list is empty" <|
            --     \() ->
            --         Expect.equal "a" (String.left 1 "abcdefg")
            ]
        -- , describe "Date parser"
        --     [ test "should return parsed date parts" <|
        --         \() ->
        --             Expect.equal (dateParse "2017/3/4") <| Just (2017, 3, 4) 
        --     , test "should handle two-digit notation" <|
        --         \() ->
        --             Expect.equal (dateParse "2017/04/03") <| Just (2017, 4, 3) 
        --     , test "should return nothing on malformed value" <|
        --         \() ->
        --             Expect.equal (dateParse "2017") Nothing
        --     ]
        ]
