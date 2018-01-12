module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
import Tachyons exposing (classes, tachyons)
import Tachyons.Classes
    exposing
        ( flex
        , flex_auto
        , flex_none
        , pointer
        , pa3
        , ph4
        , mr3
        , mt3
        , ml2
        , mr2
        , items_center
        , bg_orange
        , strike
        , outline_0
        )


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


removeFrom { todo } task =
    List.filter task todo


type alias Model =
    { done : List String
    , todo : List String
    , task : String
    }


model : Model
model =
    Model [ "done" ] [ "Create", "a", "todo" ] ""


type Msg
    = Add
    | Input String
    | Done String
    | Restore String
    | Delete String
    | KeyDown Int


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


update : Msg -> Model -> Model
update msg model =
    let
        removeTask : String -> String -> Bool
        removeTask item task =
            item /= task
    in
        case msg of
            Input item ->
                { model | task = item }

            Add ->
                addTask model

            Done task ->
                { model
                    | done = List.append model.done [ task ]
                    , todo = List.filter (notThisOne task) model.todo
                }

            Restore task ->
                { model
                    | done = List.filter (notThisOne task) model.done
                    , todo = List.append model.todo [ task ]
                }

            Delete task ->
                { model
                    | done = List.filter (notThisOne task) model.done
                }

            KeyDown code ->
                if code == 13 then
                    addTask model
                else
                    model


notThisOne : String -> String -> Bool
notThisOne task item =
    task /= item


addTask : Model -> Model
addTask model =
    { model
        | todo = List.append model.todo [ model.task ]
        , task = ""
    }


renderTodoItem : String -> Html Msg
renderTodoItem item =
    div [ onClick (Done item), listItemStyle ] [ text item ]


renderDoneItem : String -> Html Msg
renderDoneItem item =
    div [ listItemStyle, classes [ flex ] ]
        [ div [ classes [ flex_auto, strike ] ] [ text item ]
        , div [ classes [ flex_none, items_center ] ]
            [ button [ onClick (Restore item), buttonStyle, classes [ mr2 ] ] [ text "UNDO" ]
            , button [ onClick (Delete item), buttonStyle ] [ text "DELETE" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ layoutStyle ]
        [ div [ style [ ( "maxWidth", "36rem" ), ( "margin", "auto" ) ] ]
            [ div [ classes [ flex, mt3 ] ]
                [ input [ onInput Input, onKeyDown KeyDown, value model.task, classes [ flex_auto, mr3, pa3, outline_0 ] ] []
                , button [ onClick Add, buttonStyle, classes [ ph4 ] ] [ text "+" ]
                ]
            , h2 [] [ text "ToDo" ]
            , div [] (List.map renderTodoItem model.todo)
            , h2 [] [ text "Done" ]
            , div [] (List.map renderDoneItem model.done)
            ]
        ]


layoutStyle : Attribute msg
layoutStyle =
    style
        [ ( "background-color", "sienna" )
        , ( "color", "seashell" )
        , ( "padding", "5rem" )
        , ( "fontFamily", "Verdana" )
        ]


listItemStyle : Attribute msg
listItemStyle =
    style
        [ ( "padding", "1.5rem" )
        , ( "margin", "0.25rem" )
        , ( "backgroundColor", "DarkGoldenRod" )
        ]


buttonStyle : Attribute msg
buttonStyle =
    style
        [ ( "color", "seashell" )
        , ( "backgroundColor", "DarkGoldenRod" )
        , ( "border", "transparent" )
        , ( "fontSize", "90%" )
        ]
