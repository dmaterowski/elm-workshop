module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{-
   Model has been extended by newNote record that will hold new note we are editing
   1. if newNote has no value show button that populates newNote with empty Text data
   2. if newNote has value show
     - representation of it, just as it would look like in main list (hint: reuse functions!)
     - form with 3 input fields (for now using them should not change anything in model)
     - button
   3. wire up inputs with messages that update corresponding fields in newNote
     - recall how immutability in records work - we need to replace newNote with updated record (feel free to experiment in repl)
     - start with one field, add a message that will be sent to update function
     - hint: onInput
     - hint: String.toInt
     - hint: Maybe.map
   4. wire up the button to add current newNote to the beginning of main list and close the form
-}


main =
    Html.program
        { init = initial
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initial =
    ( Model defaultUser Nothing, Cmd.none )


defaultUser =
    User "Dan"
        "dmaterowski@infusion.com"
        [ TextNote { id = 1, header = "Header", text = "And some content for the sake of taking up space. And even more lines, and stuff and like you know, something meaningful." }
        , ImageNote { id = 2, url = "https://media2.giphy.com/media/12Jbd9dZVochsQ/giphy.gif" }
        , TextNote { id = 3, header = "I like trains!", text = "Choo choo!" }
        ]


type alias Model =
    { user : User
    , newNote : Maybe TextData
    }


type alias User =
    { name : String
    , email : String
    , notes : List Note
    }


type Note
    = TextNote TextData
    | ImageNote ImageData


type alias NoteData a =
    { a
        | id : Int
    }


type alias ImageData =
    NoteData
        { url : String
        }


type alias TextData =
    NoteData
        { header : String
        , text : String
        }


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )


view model =
    div []
        [ insertCss
        , insertBootstrap
        , viewPage model
        ]


viewPage model =
    div [ class "container" ]
        [ viewUser model.user
        , viewEditor model.newNote
        ]


viewUser user =
    div [ class "row" ]
        [ h1 [] [ text user.name ]
        , h2 [] [ text user.email ]
        , listNotes user.notes
        ]


viewEditor noteForm =
    div [ class "row" ]
        []


listNotes notes =
    ul [ class "list-group" ] <| List.map viewNote notes


viewNote note =
    case note of
        TextNote data ->
            li [ class "list-group-item" ]
                [ viewId data.id
                , h3 [] [ text data.header ]
                , text data.text
                ]

        ImageNote data ->
            li [ class "list-group-item" ]
                [ viewId data.id
                , img [ src data.url ] []
                ]


viewId id =
    div [ class "pull-right" ]
        [ text <| toString id ]


subscriptions model =
    Sub.none


insertCss =
    Html.node "link" [ rel "stylesheet", href "styles.css" ] []


insertBootstrap =
    Html.node "link" [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" ] []
