module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { word : String
    , guess : String
    , isCorrect : Bool
    , hint : String
    , hintLength : Int
    }


model : Model
model =
    Model "Saturday" "" False "S" 1


type Msg
    = Answer String
    | Hint
    | Reset


isCorrect : String -> String -> Bool
isCorrect a b =
    String.toLower a == String.toLower b


update : Msg -> Model -> Model
update msg model =
    case msg of
        Answer txt ->
            { model | guess = txt, isCorrect = isCorrect txt model.word }

        Hint ->
            { model | hintLength = model.hintLength + 1, hint = updateHint model }

        Reset ->
            Model "Saturday" "" False "S" 1


updateHint : Model -> String
updateHint { hintLength, word, hint } =
    if word == hint then
        hint
    else
        String.slice 0 (hintLength + 1) word


displayResult : Model -> String
displayResult { isCorrect, hint, word } =
    if hint == word then
        "You failed to guess"
    else if isCorrect then
        "You Guessed correctly"
    else
        "No. Try again"


displayButton : Model -> Html Msg
displayButton { isCorrect, hint, word } =
    if isCorrect || hint == word then
        button [ onClick Reset ] [ text "Try Again" ]
    else
        button [ onClick Hint ] [ text "Hint" ]


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("I'm thinking of a word that starts with " ++ model.hint) ]
        , input [ onInput Answer, placeholder "Guess here" ] [ text "" ]
        , displayButton model
        , div [] [ text (displayResult model) ]
        ]
