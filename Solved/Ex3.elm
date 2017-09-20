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
    { counter : Int
    }


type Msg
    = Increment
    | Decrement


initModel : Model
initModel =
    Model 0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1 }
        Decrement -> 
            { model | counter = model.counter - 1 }


view : Model -> Html Msg
view model =
    div [ style [ centered ] ]
        [ button [ onClick Decrement ] [ text "-1" ]
        , div [style [ margin20 ]] [text (toString model.counter)]
        , button [ onClick Increment ] [ text "+1" ]
        ]


centered = ( "text-align", "center" )
margin20 = ( "margin", "20px" )