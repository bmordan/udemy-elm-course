module UserInput exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { text : String }


model : Model
model =
    { text = "" }


type Msg
    = Text String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Text txt ->
            { model | text = txt }


addBackground : Attribute msg
addBackground =
    style
        [ ( "backgroundImage", "url(http://hight3ch.com/wp-content/uploads/2015/05/maxresdefault-7.jpg)" )
        , ( "backgroundSize", "cover" )
        , ( "position", "absolute" )
        , ( "top", "0" )
        , ( "bottom", "0" )
        , ( "left", "0" )
        , ( "right", "0" )
        ]


positionInput : Attribute msg
positionInput =
    style
        [ ( "position", "absolute" )
        , ( "bottom", "0" )
        , ( "left", "50%" )
        , ( "transform", "translate(-50%, -100%)" )
        ]


addOutputStyle : Attribute msg
addOutputStyle =
    style
        [ ( "fontSize", "12rem" )
        , ( "color", "#1a0d1f" )
        , ( "textAlign", "center" )
        , ( "position", "absolute" )
        , ( "top", "50%" )
        , ( "left", "50%" )
        , ( "transform", "translate(-50%, -50%)" )
        ]


view : Model -> Html Msg
view model =
    div [ addBackground ]
        [ input [ placeholder "type your text here", onInput Text, positionInput ] []
        , div [ addOutputStyle ] [ text model.text ]
        ]
