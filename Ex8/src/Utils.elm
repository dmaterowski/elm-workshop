module Utils exposing (onEnterKeyUp)

import Json.Decode as Json
import Html.Events exposing (..)
import Html exposing (..)

onEnterKeyUp : msg -> Attribute msg
onEnterKeyUp msg =
  on "keyup" (keyCode |> Json.andThen (onlyEnterKeyDecoder msg)) 

onlyEnterKeyDecoder : msg -> number -> Json.Decoder msg
onlyEnterKeyDecoder msg key =
  case key of 
    13 -> 
      Json.succeed msg
    _ -> 
      Json.fail "Key code not 13"
