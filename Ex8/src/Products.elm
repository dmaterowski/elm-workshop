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
  { productId : Int
  , name : String
  , price : Float
  , details : String
  , imgUrl : String
  , isSelected : Bool
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
  | Select Int

update : Msg -> Model -> User.CurrentUser -> (Model, Cmd Msg, Maybe String)
update msg model currentUser =
  case msg of 
    SearchQueryChange newQuery ->
      ( { model | searchQuery = newQuery }, Cmd.none, Nothing)

    SearchResult (Ok value) ->
      ({ model | products = value }, Cmd.none, Nothing)
      

    SearchResult (Err _) ->
      (model, Cmd.none, Nothing)

    SearchRequest ->
      (model, Cmd.batch [ Http.send SearchResult <| authorizedGetRequest currentUser "api/values" decodeProducts], Nothing)

    Select id ->
      let 
        toggle product =
          if product.productId == id then
            { product | isSelected = not product.isSelected }
          else 
            product
      in
        ({ model | products = List.map toggle model.products }, Cmd.none, Just "value")


decodeProducts =
  JD.list decodeProduct

decodeProduct =
  JD.map6 Product
    (JD.at ["ProductId"] JD.int)
    (JD.at ["Name"] JD.string)
    (JD.at ["Price"] JD.float)
    (JD.at ["Details"] JD.string)
    (JD.at ["ImageUrl"] JD.string)
    (JD.succeed False)


view model toMsg =
  div [] ((text "Products: ") :: List.map (viewProduct toMsg) model.products ++ [button [] [text "Save"], button [] [text "Load"]])

viewProduct toMsg product =  
  p [ onClick (toMsg <| Select product.productId), class (if product.isSelected then "highlighted" else "")] [img [src product.imgUrl, style [("height", "50px")]] [], text product.name]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
       