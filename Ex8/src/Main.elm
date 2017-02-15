port module Main exposing (main)

import Task
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value, href, attribute, style)
import Html.Events exposing (..)
import Navigation
import Http
import Products
import Login
import User.Data as User
import Mouse

port saveUser : Maybe User.UserData -> Cmd msg


type alias Model = 
  { page : Page
  , products : Products.Model
  , login : Login.Model
  , currentUser : User.CurrentUser
  , mouseX : Int
  , mouseY : Int
  }


type Msg
  = NoOp
  | ChangePage Page
  | Navigate Page
  | ProductsMsg Products.Msg
  | LoginMsg Login.Msg
  | Logout

type Page
  = NotFound
  | Public PublicPage 
  | User UserPage

type PublicPage 
  = Landing
  | Login

type UserPage 
  = Products
  | Customization


type alias Flags =
  { userData : Maybe User.UserData 
  }


init: Flags -> Navigation.Location -> (Model, Cmd Msg)
init flags location = 
    let 
        user = User.userFromStorage flags.userData
        page = hashToPage location.hash |> changeWithPermissions user

        ( productsInitModel, productsInitCmd ) =
            Products.init user
        
        ( loginInitModel, loginInitCmd ) =
            Login.init
    in
    ( 
        { page = page
        , products = productsInitModel
        , login = loginInitModel
        , currentUser = user
        , mouseX = -5
        , mouseY = -5
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

    Navigate page ->
      ( model, Navigation.newUrl <| pageToHash page)

    ChangePage page ->
      let 
        updatedPage = changeWithPermissions model.currentUser page 
      in
      ( { model | page = updatedPage }, Cmd.none)
    
    ProductsMsg msg ->
      let 
          ( productsModel, cmd ) =
              Products.update msg model.products model.currentUser
      in 
          ( { model | products = productsModel }, Cmd.batch [ Cmd.map ProductsMsg cmd])

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
              (updatedModel, updatedCmd) = update (ChangePage <| User Products) { model | login = loginModel, currentUser = User.LoggedIn data}
            in
             (updatedModel, Cmd.batch [ saveUser <| Just data, updatedCmd, Cmd.map LoginMsg cmd ] )

    Logout ->
      let 
        ( updatedModel, newCmd ) = update ( ChangePage ( Public Landing ) ) model
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
view model = viewLayout model


viewDialogContainer : (a -> Html m) -> a -> Html m
viewDialogContainer contentView content = div [class "row"]
    [ div [class "col-md-4 col-md-offset-4 custom-dialog"] 
        [ contentView content
        ]
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
          Products.view model.products ProductsMsg

        User Customization ->
          h1 [] [text "Customization"]

  in 
    div [ class "row" ] 
      [ div [class "col-md-8 col-md-offset-2" ] [ page ]
      , div [class "heart", style [("position", "fixed"), ("left", toString model.mouseX ++ "px"), ("top", toString model.mouseY ++ "px")]] [text " "] 
      ]


viewLayout : Model -> Html Msg
viewLayout model = div [] [ pageHeader model
    , viewCurrentPage model
    , footer [class "footer"] [text "Footer"]
    ]

pageHeader : Model -> Html Msg
pageHeader model = header [class "header"] 
    [  nav [class "navbar navbar-default navbar-static-top"]
        [ div [class "container"] 
            [ ul [class "nav navbar-nav"] 
                (li [] [ a [ onClick <| Navigate (Public Landing)
                            , class "navbar-brand"
                            , attribute "role" "button"] 
                            [ text "Sharks Inc." ] ]           
                 :: loggedInNavigationButtons model.currentUser)
                 
              ,Login.viewLoginWidget model.currentUser (Navigate (Public Login)) Logout (Navigate (Public Login))
                
            ]

        ]
       
    ]

loggedInNavigationButtons currentUser = 
  case currentUser of 
    User.LoggedIn data ->
      [ li [] [ a [ onClick <| Navigate (User Products)
                  , attribute "role" "button"] 
                  [text "Products"]]
      , li [] [ a [ onClick <| Navigate (Public Landing)
                  , attribute "role" "button"] 
                  [ text "Customization"] ]
      ]
    _ -> []

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

hashToPage : String -> Page
hashToPage hash =
    case hash of 
        "#/" ->
            Public Landing
        "" -> 
            Public Landing
        "#/login" -> 
            Public Login

        "#/products" ->
            User Products

        _ -> 
            NotFound

pageToHash : Page -> String
pageToHash page = 
    case page of 
        NotFound -> 
          "#/notfound"
        Public Landing ->
          "#/"
        Public Login -> 
          "#/login"
        User Products ->
          "#/products"
        User Customization ->
          "#/customization"

locationToMessage : Navigation.Location -> Msg
locationToMessage location = 
    location.hash 
    |> hashToPage
    |> ChangePage

main =
  Navigation.programWithFlags locationToMessage
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }