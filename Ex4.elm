module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


{-
   1. Start by displaying user data as headers
   2. Uncomment notes data in profile and implement data model
   3. Display list of notes
     - hint: you can use bootstrap classes (suggested: list-group, list-group-item, pull-right) or create custom ones in styles.css
     - use Html package documentation: http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#ul
-}


main =
    Html.beginnerProgram
        { model = initial
        , view = view
        , update = update
        }


initial =
    Model defaultUser


defaultUser =
    User "Dan"
        "elm-workshop@mostlybugless.com"



-- [ TextNote { id = 1, header = "Header", text = "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful." }
-- , ImageNote { id = 2, url = "http://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif" }
-- , TextNote { id = 3, header = "I like trains!", text = "Choo choo!" }
-- ]


type alias Model =
    { user : User
    }


type alias User =
    { name : String
    , email : String

    --, notes : List Note
    }


type Note
    = ImageNote ImageData



{-
   extensible record! - ImageData will contain both id and url
-}


type alias NoteData a =
    { a
        | id : Int
    }


type alias ImageData =
    NoteData
        { url : String
        }


type Msg
    = None


update msg model =
    model


view model =
    div []
        [ insertCss
        , insertBootstrap
        , viewUser model.user
        ]


viewUser user =
    div [ class "container" ]
        [ text "start off by showing user data"
        ]



-- hacking in css stylesheets (due to elm-reactor usage) - this is NOT production-quality solution


insertCss =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "styles.css" ] []


insertBootstrap =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" ] []
