import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
  Html.program
    { init = initial
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    
initial = ( Model defaultUser 
  , Cmd.none )
  
defaultUser = User "Dan" "dmaterowski@infusion.com" 

  
type alias Model = 
  { user : User
  }
  
-- !
  


type Msg =
  None
  
update msg model =
  (model, Cmd.none)



view model =
  div [ style [("width", "400px"), ("margin-left", "250px")]]
  [ viewUser model.user
  ]
   
viewUser user =
-- !
 

subscriptions model =
  Sub.none




