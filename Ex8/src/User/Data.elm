module User.Data exposing (..)

type alias UserCredentials = 
  { userName : String
  , password : String
  }

type alias UserData =
 { userName : String
 , token : String }

type CurrentUser
    = Anonymous
    | LoggedIn UserData

userFromStorage : Maybe UserData -> CurrentUser
userFromStorage data =
    case data of
        Nothing -> 
            Anonymous
        Just userData ->
            LoggedIn userData

emptyCredentials = UserCredentials "" ""