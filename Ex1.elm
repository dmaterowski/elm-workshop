import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main = Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }


    