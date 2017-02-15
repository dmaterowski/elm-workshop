module Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value, href, attribute)
import Html.Events exposing (..)
import Http 
import Json.Decode as Json
import Utils exposing (onEnterKeyUp)
import User.Data exposing (..)

type alias Model =
 { credentials : UserCredentials
 , message : String
 }

init = Model emptyCredentials "" ! []




type Msg
  = UsernameChanged String
  | PasswordChanged String
  | LoginRequested
  | TokenResult (Result Http.Error UserData)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe UserData )
update msg model =
  case msg of
    UsernameChanged newUserName ->
        ( { model | credentials = updateUsername model.credentials newUserName }, Cmd.none, Nothing)

    PasswordChanged newPassword ->
        ( { model | credentials = updatPassword model.credentials newPassword }, Cmd.none, Nothing)

    LoginRequested ->
        ( { model | credentials = emptyCredentials }, makeLoginRequest model.credentials, Nothing)

    TokenResult (Ok value) -> 
        ( { model | message = "Success!" }, Cmd.none, Just value)

    TokenResult (Err _) ->
        ( { model | message = "Error"}, Cmd.none, Nothing)

makeLoginRequest credentials = 
    let 
        url = "http://elm-mock.azurewebsites.net/token"
        body = Http.stringBody "application/x-www-form-urlencoded" 
            ("grant_type=password&" ++ "username=" ++ credentials.userName ++ "&password=" ++ credentials.password)
        request =
            Http.post url body decodeUserData
    in 
        Http.send TokenResult request

updateUsername credentials newUsername =
    ( { credentials | userName = newUsername } )

updatPassword credentials newPassword =
    ( { credentials | password = newPassword } )

decodeUserData = Json.map2 UserData (Json.field "userName" Json.string) (Json.field "access_token" Json.string)

viewLoginDialog : Model -> Html Msg
viewLoginDialog model = 
  form []  
    [ input [ placeholder "Username", onInput UsernameChanged
            , value model.credentials.userName, class "form-control" ] []
    , input [ placeholder "Password", onInput PasswordChanged, onEnterKeyUp LoginRequested
            , value model.credentials.password, type_ "password", class "form-control" ] []
    , button [ onClick LoginRequested, class "btn btn-success", type_ "button" ] [text "Login"]
    ]

viewLoginWidget currentUser navigateLogin doLogout navigateDetails =
    case currentUser of
        Anonymous ->
            ul [class "nav navbar-nav navbar-right"] 
                        [ li [] [a [onClick <| navigateLogin
                                    , class "navbar-right"
                                    , attribute "role" "button"] 
                                    [ text "Login"] ]
                        ] 
        LoggedIn userData ->
            ul [class "nav navbar-nav navbar-right"] 
                        [ li [] [ a [onClick <| doLogout
                                    , class "navbar-right"
                                    , attribute "role" "button"] 
                                    [ text "Logout"]
                                , a [onClick <| navigateDetails
                                    , class "navbar-right"
                                    , attribute "role" "button"] 
                                    [ text userData.userName]
                                ]
                        ] 



