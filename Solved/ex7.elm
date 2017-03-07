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
    
initial = ( Model defaultUser Closed 
  , Cmd.none )
  
defaultUser = User "Dan" "dmaterowski@infusion.com" 
  [ TextNote (TextData 1 "Header" "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful.")
  , ImageNote (ImageData 2 "http://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif")
  , TextNote (TextData 3 "I like trains" "Really!!!")]

  
type alias Model = 
  { user : User
  , form : Form
  }
  
type alias User =
  { name : String
  , email: String
  , notes : List Note 
  }
  
type Form = 
  Closed
  | TextForm TextData


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
  
emptyTextNote =
  TextData 0 "" "" 

type Msg =
  Open
  | Add 
  | Update TextField
  | AddImage
  | NewImage (Result Http.Error String)
  
type TextField =
  Id String
  | Header String
  | Text String
  
update msg model =
  case msg of
    Open ->
      ({ model | form = TextForm emptyTextNote }, Cmd.none)

    Update field ->
      ( { model | form = updateForm model.form field}, Cmd.none)

    Add ->
      ( { model | user = addNote model.user model.form, form = Closed}, Cmd.none)

    AddImage ->
      ( model, getSharks)

    NewImage (Ok newUrl) ->
      ( { model | user = addImage model.user newUrl} , Cmd.none)

    NewImage (Err _) ->
      (model, Cmd.none)

getSharks =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=sharks" 
  in
    Http.send NewImage (Http.get url decodeUrl)

decodeUrl =
  Decode.at ["data", "image_url"] Decode.string


updateForm form field =
  case form of 
    TextForm form ->
      case field of
        Id id ->
          let 
            converted = String.toInt id |> Result.withDefault 0
          in
            TextForm { form | id = converted }
        Header header ->
          TextForm { form | header = header }
        Text text ->
          TextForm { form | text = text }
    _ -> 
       form

addNote user form =
  case form of 
    TextForm textData ->
     { user | notes = (TextNote textData :: user.notes )}
    _ -> user

addImage user url =
  { user | notes = (ImageNote (ImageData 2 url) :: user.notes )}
  
view model =
  div [ style [("width", "400px"), ("margin-left", "250px")]]
  [ viewUser model.user
  , viewForm model.form
  ]
   
viewUser user =
  div []
   [ h1 [] [ text user.name ]
   , h2 [] [ text user.email ]
   , listNotes user.notes
   ]
 
listNotes notes =
   Keyed.ul [] <| List.map viewNote notes
   
viewNote note =
   case note of 
     TextNote data ->
       (toString data.id, li [] 
        [ h3 [] [ text data.header ]
        , viewId data.id
        , text data.text
       ])
     ImageNote data ->
       (data.url , li [] 
         [ img [ src data.url, style [("width", "350px")]] []
       , viewId data.id] )
       
viewId id =
  div [style [("float", "right"), ("background", "lightgreen"), ("border-radius", "5px"), ("width", "10px")]] 
            [text <| toString id]
            
viewForm state =
  case state of 
    Closed ->
      div [] 
        [ button [ onClick Open ] [text "Add" ]
        , button [ onClick AddImage ] [text "AddImage" ]
        ]
    TextForm data ->
      div []
        [ div [style [("border", "1px solid black"), ("padding", "20px")]] [ listNotes [TextNote data] ]
        , input [ style [("margin-top", "10px")], type_ "text", placeholder "id", onInput (Update << Id)] []
        , input [ type_ "text", placeholder "header", onInput (Update << Header)] []
        , input [ type_ "text", placeholder "text", onInput (Update << Text)] []
        , button [ onClick Add ] [text "Add" ]
        ]
      

subscriptions model =
  Sub.none




