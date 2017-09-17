module ExEncoders exposing (..)

import Array
import Json.Encode exposing (..)


-- Docs: http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Encode
{-
   Run:
   - elm-repl
   - import ExEncoders exposing (..)

   Part 1
   Primitive values
   In order to encode Elm values to Json.Encode.Value type we can use useful function which can be found below
-}


s =
    string "Thix is some text"


i =
    int 7


f =
    float 3.14


b =
    bool True



-- We can have null inside Json, right?


n =
    null



{-
   To create list of values, use list
-}


numbersList =
    [ 1, 2, 3 ]
        |> List.map int
        |> list



{-
   To create object, use object function
-}


o =
    [ ( "name", string "Mike" )
    , ( "surname", string "Wazowski" )
    , ( "id", int 123 )
    , ( "points", numbersList )
    ]
        |> object



{-
   In order to obtain a string with encoded JSON Value, use `encode` function.
   Test it on all Json values from this file.
   encode 0 val
   0 means no indentation - feel free to experiment with this integer value!
-}


sStr =
    encode 0 s


iStr =
    encode 4 i


fStr =
    encode 0 f


bStr =
    encode 0 b


nStr =
    encode 0 n


nlStr =
    encode 4 numbersList


oStr =
    encode 4 o



{-
   Exercise: try to encode some nested JSON object hierarchy and check if the produced string is ok.
-}


nested =
    object
        [ ( "data"
          , list
                [ object [ ( "x", int 1 ), ( "y", int 1 ) ]
                , object [ ( "x", int 2 ), ( "y", int 2 ) ]
                , object [ ( "x", int 3 ), ( "y", int 3 ) ]
                ]
          )
        ]


nestedStr =
    encode 4 nested



{-
   Such JSON object encoded as a string can be, for example, sent to a server in HTTP request body.
-}
