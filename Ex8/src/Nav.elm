module Nav exposing (..)

type Page
  = NotFound
  | Public PublicPage 
  | User UserPage

type PublicPage 
  = Landing
  | Login

type UserPage 
  = Products
  | Customization

type Msg =
   ChangePage Page
  | Navigate Page
  | Logout

hashToPage : String -> Page
hashToPage hash =
    case hash of 
        "#/" ->
            Public Landing
        "" -> 
            Public Landing
        "#/login" -> 
            Public Login

        "#/products" ->
            User Products

        _ -> 
            NotFound

pageToHash : Page -> String
pageToHash page = 
    case page of 
        NotFound -> 
          "#/notfound"
        Public Landing ->
          "#/"
        Public Login -> 
          "#/login"
        User Products ->
          "#/products"
        User Customization ->
          "#/customization"


locationToMessage toMsg location  = 
    location.hash 
    |> hashToPage
    |> (toMsg << ChangePage)