module Playground exposing (..)

import Html exposing (Html, button, div, text)
import Config

main = Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

type alias Model = Int

type Msg 
    = Test

model : Model
model = 
    0
    
update : Msg -> Model -> Model
update msg model =
    case msg of Test
        -> model + 1

view : Model -> Html Msg
view model =
    div [] [
        handPoints myHand |> toString  |> text
    ]

type Figure = 
      Two  | Three | Four  | Five 
    | Six  | Seven | Eight | Nine 
    | Ten  | Jack  | Queen | King | Ace

type Suit = Diamonds | Spades | Hearts | Clubs

type Card = Card Figure Suit
    
myHand = [ Card Jack Diamonds, Card Three Spades ] 

handPoints hand = 
    List.map points hand 
    |> List.sum

points card =
    case card of
        Card Ace _ -> 5
        Card King _ -> 4
        Card Queen _ -> 3
        Card Jack _ -> 2
        _ -> 1


showSomething = text "data"

square n = 
  n^2