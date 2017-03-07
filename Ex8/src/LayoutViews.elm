module LayoutViews exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value, href, attribute, style)
import Html.Events exposing (..)
import Login
import Nav exposing(..)
import User.Data as User


pageHeader model toMsg = header [class "header"] 
    [  nav [class "navbar navbar-default navbar-static-top"]
        [ div [class "container"] 
            [ ul [class "nav navbar-nav"] 
                (li [] [ a [ onClick <| toMsg <| Navigate (Public Landing)
                            , class "navbar-brand"
                            , attribute "role" "button"] 
                            [ text "Sharks Inc." ] ]           
                 :: loggedInNavigationButtons model.currentUser toMsg)
                 
              ,Login.viewLoginWidget model.currentUser (toMsg <| Navigate (Public Login)) (toMsg <| Logout) 
               (toMsg <| Navigate (Public Login))
                
            ]

        ]
       
    ]


viewDialogContainer : (a -> Html m) -> a -> Html m
viewDialogContainer contentView content = div [class "row"]
    [ div [class "col-md-4 col-md-offset-4 custom-dialog"] 
        [ contentView content
        ]
    ]

loggedInNavigationButtons currentUser toMsg = 
  case currentUser of 
    User.LoggedIn data ->
      [ li [] [ a [ onClick <| toMsg <| Navigate (User Products)
                  , attribute "role" "button"] 
                  [text "Products"]]
      , li [] [ a [ onClick <| toMsg <| Navigate (Public Landing)
                  , attribute "role" "button"] 
                  [ text "Customization"] ]
      ]
    _ -> []
