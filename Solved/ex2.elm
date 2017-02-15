module Ex2 exposing(..)


square n =
  n^2

hypotenuse a b =
  sqrt (square a + square b)

distance (a,b) (x,y) =
  hypotenuse (a-x) (b-y)

squareAnon =
  \n -> n^2

squares =
  List.map (\n -> n^2) (List.range 1 10)

add5 x = 
  x + 5

calculate val =
  val
  |> square
  |> clamp 5 40
  |> add5

validate val =
  (False, "So wrong I can't even comprehend it")

improve val =
  let 
    calculated = calculate val
    squared = square val
    (isValid, error) = validate val
  in
  if isValid then
    calculated + squared
  else if error == "Something" then
    0
  else
    5
