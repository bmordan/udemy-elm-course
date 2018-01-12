module HelloTwo exposing (..)

import Html exposing (text, div, h1, ul, li, p)
import Html.Attributes exposing (class)


main : Html.Html msg
main =
    div []
        [ h1 [] [ text "Who is ok?" ]
        , renderStatues statuses
        ]


renderStatues : List String -> Html.Html msg
renderStatues lst =
    ul [] (List.map createLi lst)


createLi : String -> Html.Html msg
createLi str =
    li [] [ text str ]


statuses : List String
statuses =
    [ "you are ok"
    , "they are ok"
    , "everyone is ok"
    ]
