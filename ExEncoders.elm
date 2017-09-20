module ExEncoders exposing (..)

import Array
import Json.Encode as Encode


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
    Encode.string "Thix is some text"


i =
    Encode.int 7


f =
    Encode.float 3.14


b =
    Encode.bool True



-- We can have null inside Json, right?


n =
    Encode.null



{-
   To create list of values, use list
-}


numbersList =
    [ 1, 2, 3 ]
        |> List.map Encode.int
        |> Encode.list



{-
   To create object, use object function
-}


o =
    [ ( "name", Encode.string "Mike" )
    , ( "surname", Encode.string "Wazowski" )
    , ( "id", Encode.int 123 )
    , ( "points", numbersList )
    ]
        |> Encode.object



{-
   In order to obtain a string with encoded JSON Value, use `encode` function.
   Test it on all Json values from this file (o, numbersList, i, b, n, ...)
   encode 0 val
   0 means no indentation - feel free to experiment with this integer value!
-}


iStr =
    Encode.encode 0 i



{-
   Exercise: try to encode some nested JSON object hierarchy and check if the produced string is ok.
-}
{-
   Such JSON object encoded as a string can be, for example, sent to a server in HTTP request body.
-}
