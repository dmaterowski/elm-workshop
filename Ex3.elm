module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }


type alias Model =
    { 
    }


type Msg
    = Increment


initModel : Model
initModel =
    Model 


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div [] [ text "Success!"]


