module Tests exposing (..)

import Ex2 exposing (..)
import Expect
import Test exposing (..)


all : Test
all =
    describe "Ex2 test suite"
        [ describe "1. selectionParser should"
            [ test "return empty list for empty selection" <|
                \() ->
                    Expect.equal [] (selectionToValues Empty)
            , test "return single item for single selection" <|
                \() ->
                    Expect.equal [ "single" ] (selectionToValues <| Single "single")
            , test "return all items for single selection" <|
                \() ->
                    Expect.equal [ "one", "two", "three" ] (selectionToValues <| Multiple [ "one", "two", "three" ])
            ]
            
        -- , describe "2. extendSelection should"
        --     [ test "return single item if selection empty" <|
        --         \() ->
        --             Expect.equal (Single "value") (extendSelection "value" Empty)
        --     , test "return multiple items for multiple selection" <|
        --         \() ->
        --             Expect.equal (Multiple [ "value", "original" ]) (extendSelection "value" <| Single "original")
        --     , test "return all items for single selection" <|
        --         \() ->
        --             Expect.equal (Multiple [ "value", "original1", "original2" ]) (extendSelection "value" <| Multiple [ "original1", "original2" ])
        --     ]

        -- , describe "3. toSelection should"
        --     [ test "return empty item for empty list" <|
        --         \() ->
        --             Expect.equal Empty (toSelection [])
        --     , test "return single item for single value" <|
        --         \() ->
        --             Expect.equal (Single "value") (toSelection [ "value" ])
        --     , test "return multiple selection for multiple values" <|
        --         \() ->
        --             Expect.equal (Multiple [ "first", "second" ]) (toSelection [ "first", "second" ])
        --     ]

        -- , describe "4. filteredToUppercaseString should"
        --     ( let testFiltering = \expected selection -> test ("process value of" ++ toString selection) <|
        --         \() ->
        --             Expect.equal expected (filteredToUppercaseString selection)
        --       in
        --       [ describe "capitalize values and"
        --         [ testFiltering ["VALUE"] <| Single "value"
        --         , testFiltering ["FIRST", "SECOND"] <| Multiple ["first", "second"]
        --         ]
        --       , describe "filter bananas and "
        --         [ testFiltering [] <| Single "bananas"
        --         , testFiltering [] <| Single "BANANAS"
        --         , testFiltering [] <| Single "bAnaNas"
        --         , testFiltering ["SECOND"] <| Multiple ["bananas", "second"]
        --         ]
        --       ]
        --     )
        ]
