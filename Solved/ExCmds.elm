module Main exposing (..)

import Array exposing (Array)
import Random
import Html exposing (Html, div, h1, p, blockquote, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


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


init : ( Model, Cmd Msg )
init =
    ( model, callForRandomQuote secretQuotes )



-- UPDATE


type Msg
    = AskForQuote
    | ReturnQuote (Maybe Quote)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AskForQuote ->
            ( model, callForRandomQuote secretQuotes )

        ReturnQuote quote ->
            ( { model | quote = quote }, Cmd.none )


callForRandomQuote : Array Quote -> Cmd Msg
callForRandomQuote quotes =
    let
        randomQuoteGenerator =
            Random.map (\n -> Array.get n quotes) <| Random.int 0 (Array.length quotes - 1)
    in
        Random.generate ReturnQuote randomQuoteGenerator



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "A pinch of Elmspiration..." ]
        , viewQuote model
        , viewButton
        ]


viewQuote : Model -> Html Msg
viewQuote model =
    case model.quote of
        Just quote ->
            let
                quoteText =
                    Maybe.withDefault "" <| Maybe.map .text model.quote

                quoteAuthor =
                    Maybe.withDefault "" <| Maybe.map .author model.quote
            in
                div []
                    [ blockquote
                        [ style
                            [ ( "border-left", "0.5em solid #cfcfcf" )
                            , ( "padding", "0.5em" )
                            , ( "font-family", "serif" )
                            , ( "font-style", "italic" )
                            ]
                        ]
                        [ text quoteText ]
                    , div
                        [ style [ ( "margin", "1em 4.5em" ) ] ]
                        [ text quoteAuthor ]
                    ]

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
