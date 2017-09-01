import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main = Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }

type alias Model = Int

type Msg 
    = Increment

initModel : Model
initModel = 
    0
    
update : Msg -> Model -> Model
update msg model =
    case msg of Increment
        -> model + 1

view : Model -> Html Msg
view model =
    div [] 
    [ text (toString model)
    , button [ onClick Increment ] [ text "Add" ]
    ]
    