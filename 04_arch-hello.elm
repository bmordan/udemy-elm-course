module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { text : String
    , size : Int
    }


model : Model
model =
    { text = "Hello World"
    , size = 1
    }


type Msg
    = Text
    | Bigger
    | Smaller
    | Delete


update : Msg -> Model -> Model
update msg model =
    case msg of
        Delete ->
            { model | text = removeBang model.text }

        Text ->
            { model | text = model.text ++ "!" }

        Bigger ->
            { model | size = model.size + 1 }

        Smaller ->
            { model | size = clamp 1 6 (model.size - 1) }


removeBang : String -> String
removeBang txt =
    if String.endsWith "!" txt then
        String.dropRight 1 txt
    else
        txt


myStyle : Int -> Attribute msg
myStyle size =
    style
        [ ( "fontSize", toString size ++ "rem" )
        , ( "color", "hotpink" )
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ myStyle model.size ] [ text model.text ]
        , button [ onClick Delete ] [ text "Delete !" ]
        , button [ onClick Text ] [ text "Add !" ]
        , button [ onClick Bigger ] [ text "Bigger" ]
        , button [ onClick Smaller ] [ text "Smaller" ]
        ]
