module Ex2 exposing (..)

{-
  1. 
    Maybe is actually defined as:
      type Maybe a
        = Just a
        | Nothing
    "type" (in contrast to type alias) allows us to declare union types
-}

type Selection
  = Empty
  | Single String
  | Multiple (List String)
  | Advanced String CustomItemData

{-
  Run test set in tests/Tests.elm and implement function selectionToValues
  - <| operator is defined here: http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Basics#<| 
  - what will be the type annotation of selectionToValues?
-}

selectionToValues selection =
  case selection of
    Empty -> []
    Single value -> [value]
    Multiple values -> values
    Advanced value data -> [value]

{-
  2. Back to lists!
    Uncomment second set of tests and implement function extendSelection
    - "cons" operator (::) adds item to the front of the list: (::) : a -> List a -> List a 
-}

extendSelection value selection =
    case selection of
      Empty -> Single value
      Single original -> Multiple [value, original]
      Multiple originalValues -> Multiple <| value :: originalValues
      Advanced value data -> selection
      


{-
  3. It turns out we need additional logic for processing of custom items!
    Add new possible value to Selection type that holds String and CustomItemData
    - talk with your compiler to get every regression fixed
    - assume Advanced selection cannot be extended and returns original selection
-}

type alias CustomItemData =
  { description: String
  , features: List Int
  }


{-
  4. Pattern matching on lists:
    Uncomment next set of tests and implement toSelection function
    - you can match (case .. of) on elements, e.g. [], [single], [first, second]
-}
toSelection: List String -> Selection
toSelection values =
  case values of
    [] -> Empty
    [value] -> Single value
    values -> Multiple values


{-
  4. Processing
    Uncomment next set of tests and implement filteredToUppercaseString function
    - "bananas" have to be filtered out (case insensitive)

    - pipe (|>) operator
    - consider reusing selectionToValues
    - hint: List.map, String.toUpper, List.filter 
    - definitions: 
      http://package.elm-lang.org/packages/elm-lang/core/5.1.1/List
      http://package.elm-lang.org/packages/elm-lang/core/5.1.1/String
-}

filteredToUppercaseString: Selection -> List String
filteredToUppercaseString selection =
  selection 
  |> selectionToValues
  |> List.map String.toUpper
  |> List.filter (\v -> v /= "BANANAS")