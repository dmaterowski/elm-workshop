module Main exposing (..)

import Array exposing (Array)
import Random
import Html exposing (Html, div, h1, p, blockquote, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


{-
   Commands and Random
   In order to test this program, run:
   elm-reactor

   And click ExCmds.elm - this file will be compiled and built for you by elm-reactor
   Follow instructions for TODOs below
-}
-- MODEL


type alias Quote =
    { text : String
    , author : String
    }


type alias Model =
    { quote : Maybe Quote
    }


model : Model
model =
    { quote = Nothing
    }



{-
   TODO
   1. Load random quote once Elm has started
   Hint - look at the second part of the tuple when there is a valid command - it will be executed by Elm Runtime during model initial load!
-}


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = AskForQuote
    | ReturnQuote (Maybe Quote)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AskForQuote ->
            let
                maxValue = Array.length secretQuotes - 1
                getNthSecretQuote n = Array.get n secretQuotes
                randomQuoteGenerator =
                    Random.map getNthSecretQuote <| Random.int 0 maxValue
            in
                ( model, Random.generate ReturnQuote randomQuoteGenerator )

        ReturnQuote quote ->
            ( { model | quote = quote }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "A pinch of Elmspiration..." ]
        , viewQuote model
        , viewButton
        ]



{-
   TODO
   2. Change viewQuote function in order to display also an author of the quote!
-}


viewQuote : Model -> Html Msg
viewQuote model =
    case model.quote of
        Just quote ->
            blockquote
                [ style
                    [ ( "border-left", "0.5em solid #cfcfcf" )
                    , ( "padding", "0.5em" )
                    , ( "font-family", "serif" )
                    , ( "font-style", "italic" )
                    ]
                ]
                [ text <| Maybe.withDefault "" <| Maybe.map .text model.quote ]

        Nothing ->
            p [ style [ ( "margin", "1em 3em" ) ] ] [ text "Loading..." ]


viewButton : Html Msg
viewButton =
    button
        [ onClick AskForQuote
        , style
            [ ( "margin", "0.5em 1em" )
            , ( "padding", "0.25em 1em" )
            , ( "background", "#cfcfcf" )
            , ( "border-style", "none" )
            , ( "font-family", "serif" )
            , ( "font-weight", "bold" )
            ]
        ]
        [ text "Inspire me!" ]


subscriptions : Model -> Sub Msg
subscriptions =
    \_ -> Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


secretQuotes : Array Quote
secretQuotes =
    Array.fromList
        [ { text = "Controlling complexity is the essence of computer programming."
          , author = "Brian Kernighan"
          }
        , { text = "First, solve the problem. Then, write the code."
          , author = "John Johnson"
          }
        , { text = "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live."
          , author = "Martin Golding"
          }
        , { text = "In theory, there is no difference between theory and practice. But, in practice, there is."
          , author = "Jan L. A. van de Snepscheut"
          }
        , { text = "Once a new technology starts rolling, if you’re not part of the steamroller, you’re part of the road."
          , author = "Stewart Brand"
          }
        , { text = "You can’t have great software without a great team, and most software teams behave like dysfunctional families."
          , author = "Jim McCarthy"
          }
        , { text = "Programming is not a zero-sum game. Teaching something to a fellow programmer doesn’t take it away from you. I’m happy to share what I can, because I’m in it for the love of programming."
          , author = "John Carmack"
          }
        ]
