module Tests exposing (..)

import Expect
import Fuzz exposing (Fuzzer, list, string)
import Test exposing (..)
import Test.Runner.Html
import Ex2 exposing (..)


{- main function is for html test runner (https://github.com/elm-community/html-test-runner)
   In order to run tests using browser:
       1. Ensure you are in `tests` folder
       2. Run `elm-reactor` command
       3. Navigate in your browser to http://localhost:8000
       4. Click `Tests.elm` file
       5. Refresh, when you make changes to your elm files


    If you have problems, ask or try Ellie fallback (instructions at the end of the file)

-}


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run all



-- For instructions on how to run these tests in console, read info in `Ex2.elm` file


all : Test
all =
    describe "Ex2 test suite"
        [ describe "1. selectionParser should"
            [ test "return empty list for empty selection" <|
                \_ ->
                    Expect.equal [] (selectionToValues Empty)
            , test "return single item for single selection" <|
                \_ ->
                    Expect.equal [ "single" ] (selectionToValues <| Single "single")
            , test "return all items for multiple selection" <|
                \_ ->
                    Expect.equal [ "one", "two", "three" ] (selectionToValues <| Multiple [ "one", "two", "three" ])
            ]

        , describe "2. extendSelection should"
            [ test "return single item if selection empty" <|
                \_ ->
                    Expect.equal (Single "value") (extendSelection "value" Empty)
            , test "return multiple items for multiple selection" <|
                \_ ->
                    Expect.equal (Multiple [ "value", "original" ]) (extendSelection "value" <| Single "original")
            , test "return all items for single selection" <|
                \_ ->
                    Expect.equal (Multiple [ "value", "original1", "original2" ]) (extendSelection "value" <| Multiple [ "original1", "original2" ])
            ]
        , describe "3. toSelection should"
            [ test "return empty item for empty list" <|
                \_ ->
                    Expect.equal Empty (toSelection [])
            , test "return single item for single value" <|
                \_ ->
                    Expect.equal (Single "value") (toSelection [ "value" ])
            , test "return multiple selection for multiple values" <|
                \_ ->
                    Expect.equal (Multiple [ "first", "second" ]) (toSelection [ "first", "second" ])
            ]
        , describe "4. filteredToUppercaseString should"
            ( let testFiltering = \expected selection -> test ("process value of" ++ toString selection) <|
                \_ ->
                    Expect.equal expected (filteredToUppercaseString selection)
              in
              [ describe "capitalize values and"
                [ testFiltering ["VALUE"] <| Single "value"
                , testFiltering ["FIRST", "SECOND"] <| Multiple ["first", "second"]
                ]
              , describe "filter bananas and "
                [ testFiltering [] <| Single "bananas"
                , testFiltering [] <| Single "BANANAS"
                , testFiltering [] <| Single "bAnaNas"
                , testFiltering ["SECOND"] <| Multiple ["bananas", "second"]
                ]
              ]
            )
         -- Example of property based testing (a la QuickCheck in Haskell)
        , describe "5. Fuzzy tests (properties)"
            [ fuzz (list string) "given list of strings, when going to Selection type and back, then the result is the same as input data" <|
                \words ->
                    words
                    |> toSelection
                    |> selectionToValues
                    |> Expect.equalLists words
            , fuzz2 (list string) (list string) """given list of strings, when add "bananas" and apply filteredToUppercaseString, then the result does not contain bananas""" <|
                \beforeB afterB ->
                    beforeB ++ "banans" :: afterB
                    |> toSelection
                    |> filteredToUppercaseString
                    |> List.member "BANANAS"
                    |> Expect.false "Expected list to not contain BANANAS"
            ]
        ]

{-

    Ellie fallback

    It is possible to run these tests and whole exercise 2 in Ellie
    1. Go to: https://ellie-app.com/new
    2. Install packages: core, html, html-test-runner (community version), elm-test, eeue56/elm-html-test
    3. Replace Elm code in online editor with content of Ex2.elm and Tests.elm files
    4. Move all imports to the top of the file (remove import of Ex2)
    5. Change Html - use the name of the module: `var app = Elm.Ex2.fullscreen()` (or whatever your online module is called!)

-}