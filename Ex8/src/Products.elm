module Products exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import User.Data as User
import User.Authorization exposing (..)
import Json.Decode as JD
import Http

type alias Model =
  { products : List Product
  , searchQuery : String
  }

type alias Product =
  { name : String
  , price : Float
  , details : String
  , imgUrl : String
  } 

initModel : Model
initModel =
  { products = []
  , searchQuery = ""}

init currentUser =
  update SearchRequest initModel currentUser

type Msg 
  = SearchQueryChange String
  | SearchRequest
  | SearchResult (Result Http.Error (List Product))

update : Msg -> Model -> User.CurrentUser -> (Model, Cmd Msg)
update msg model currentUser =
  case msg of 
    SearchQueryChange newQuery ->
      ( { model | searchQuery = newQuery }, Cmd.none)

    SearchResult (Ok value) ->
      ({ model | products = value }, Cmd.none)
      

    SearchResult (Err _) ->
      (model, Cmd.none)

    SearchRequest ->
      (model, Cmd.batch [ Http.send SearchResult <| authorizedGetRequest currentUser "api/values" decodeProducts])


decodeProducts =
  JD.list decodeProduct

decodeProduct =
  JD.map4 Product
    (JD.at ["Name"] JD.string)
    (JD.at ["Price"] JD.float)
    (JD.at ["Details"] JD.string)
    (JD.at ["ImageUrl"] JD.string)


view model toMsg =
  div [] ((text "Products: ") :: List.map (viewProduct toMsg) model.products)

viewProduct toMsg product =  
  p [ ] [img [src product.imgUrl, style [("height", "50px")]] [], text product.name]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
       