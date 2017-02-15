module User.Authorization exposing (authorizedPostRequest, authorizedGetRequest)

import Http exposing (..)
import User.Data exposing (..)

post url headers body decoder =
  Http.request 
    { method = "POST"
    , headers = headers
    , url = url
    , body = body
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

get url headers body decoder =
  Http.request 
    { method = "GET"
    , headers = headers
    , url = url
    , body = body
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

baseUrl = "http://elm-mock.azurewebsites.net/"

makeEndpoint endpoint = 
  baseUrl ++ endpoint

authorizedPostRequest user endpoint body decoder =
  let 
    headers = [ Http.header "Authorization" (getToken user) ]
  in 
    post (makeEndpoint endpoint) headers body decoder

authorizedGetRequest user endpoint decoder =
  let 
    headers = [ Http.header "Authorization" (getToken user) ]
  in 
    get (makeEndpoint endpoint) headers emptyBody decoder

getToken user =
  case user of 
    Anonymous ->
      ""
    LoggedIn data ->
      "Bearer " ++ data.token
