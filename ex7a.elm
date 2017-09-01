import Html exposing (..)
import Html.Keyed as Keyed
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
    
initial = ( Model defaultUser Closed Nothing
  , Cmd.none )
  
defaultUser = User "Dan" "dmaterowski@infusion.com" 
  [ TextNote (TextData 1 "Header" "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful.")
  , ImageNote (ImageData 2 "http://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif")
  , TextNote (TextData 3 "I like trains" "Really!!!")]

  
type alias Model = 
  { user : User
  , form : FormState
  --???
  }

  
update msg model =
  case msg of

    Save ->

    
    Undo ->
    


view model =
  div [ style [("width", "400px"), ("margin-left", "250px")]]
  [ viewUser model.user
  , viewForm model.form
  ]
  

subscriptions model =
  Sub.none




