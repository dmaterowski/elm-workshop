port module Main exposing (main)

import Html
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value, href, attribute, style)
import Navigation
import LayoutViews exposing (..)
import Nav exposing (..)
import Products
import Login
import User.Data as User

port saveUser : Maybe User.UserData -> Cmd msg

type alias Model = 
  { page : Page
  , products : Products.Model
  , login : Login.Model
  , currentUser : User.CurrentUser
  }


type Msg
  = NoOp
  | ProductsMsg Products.Msg
  | LoginMsg Login.Msg
  | Navigation Nav.Msg


type alias Flags =
  { userData : Maybe User.UserData 
  }


init: Flags -> Navigation.Location -> (Model, Cmd Msg)
init flags location = 
    let 
        user = User.userFromStorage flags.userData
        page = hashToPage location.hash |> changeWithPermissions user

        ( productsInitModel, productsInitCmd) =
            Products.init user
        
        ( loginInitModel, loginInitCmd ) =
            Login.init
    in
    ( 
        { page = page
        , products = productsInitModel
        , login = loginInitModel
        , currentUser = user
        },
      Cmd.batch 
        [ Cmd.map ProductsMsg productsInitCmd
        , Cmd.map LoginMsg loginInitCmd
        ]) 





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    Navigation (Navigate page) ->
      ( model, Navigation.newUrl <| pageToHash page)

    Navigation (ChangePage page) ->
      let 
        updatedPage = changeWithPermissions model.currentUser page 
      in
      ( { model | page = updatedPage }, Cmd.none)
    
    ProductsMsg msg ->
      let 
          ( productsModel, cmd ) =
              Products.update msg model.products model.currentUser
      in 
          ( { model | products = productsModel }, Cmd.map ProductsMsg cmd)

    LoginMsg msg ->
      let 
          ( loginModel, cmd, userData ) =
            Login.update msg model.login
      in
        case userData of 
          Nothing -> 
            ( { model | login = loginModel}, Cmd.map LoginMsg cmd )
          Just data ->
            let 
              (updatedModel, updatedCmd) = update 
                (Navigation (ChangePage <| User Products)) 
                { model | login = loginModel, currentUser = User.LoggedIn data}
            in
             (updatedModel, Cmd.batch [ saveUser <| Just data, updatedCmd, Cmd.map LoginMsg cmd ] )

    Navigation Logout ->
      let 
        ( updatedModel, newCmd ) = update (Navigation (ChangePage ( Public Landing )) ) model
      in
      { updatedModel | currentUser = User.Anonymous } ! [ saveUser Nothing ] 


changeWithPermissions currentUser page  = 
  case page of
    User actual ->
      case currentUser of 
        User.Anonymous -> Public Login
        User.LoggedIn data -> page
    _ -> page

view : Model -> Html Msg
view model = viewLayout model viewCurrentPage Navigation

viewLayout model viewCurrentPage toMsg = div [] [ pageHeader model toMsg
    , viewCurrentPage model
    , footer [class "footer"] [text "Footer"]
    ]

viewCurrentPage : Model -> Html Msg
viewCurrentPage model = 
  let 
    page = 
      case model.page of
        Public Landing ->
          text "on landing"
        
        Public Login ->
          Html.map LoginMsg (viewDialogContainer Login.viewLoginDialog model.login) 

        NotFound ->
          h1 [] [text "Not found"] 

        User Products ->
          Products.view model.products

        User Customization ->
          h1 [] [text "Customization"]

  in 
    div [ class "row" ] 
      [ div [class "col-md-8 col-md-offset-2" ] [ page ]
      ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
   

main =
  Navigation.programWithFlags (locationToMessage Navigation)
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }