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
  [ TextNote (TextData 1 "Header" "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful.")
  , ImageNote (ImageData 2 "http://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif")
  , TextNote (TextData 3 "I like trains" "Really!!!")]

  
type alias Model = 
  { user : User
  }
  
type alias User =
  { name : String
  , email: String
  , notes : List Note 
  }
  

type Note = 
  TextNote TextData
  | ImageNote ImageData

type alias ImageData =
  { id : Int
  , url : String
  }
  
type alias TextData =
  { id : Int
  , header : String
  , text : String
  }
  

type Msg =
  None
  
update msg model =
  (model, Cmd.none)



view model =
  div [ style [("width", "400px"), ("margin-left", "250px")]]
  [ viewUser model.user
  ]
   
viewUser user =
  div []
   [ h1 [] [ text user.name ]
   , h2 [] [ text user.email ]
   , listNotes user.notes
   ]
 
listNotes notes =
   ul [] <| List.map viewNote notes
   
viewNote note =
   case note of 
     TextNote data ->
       li [] 
        [ h3 [] [ text data.header ]
        , viewId data.id
        , text data.text
        ]
     ImageNote data ->
       li [] 
         [ img [ src data.url, style [("width", "350px")]] []
         , viewId data.id]
       
viewId id =
  div [style [("float", "right"), ("background", "lightgreen"), ("border-radius", "5px"), ("width", "10px")]] 
            [text <| toString id]
            
      

subscriptions model =
  Sub.none




