module App exposing (..)

import Html exposing (Html, program, div, text, button, img, br)
import Html.Attributes exposing (src, style, classList)
import Html.Events exposing (onClick)
import Random
import Process
import Time
import Task


main =
    program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


type alias Model =
    { side : String
    , number : Int
    , animateCoin : Bool
    , animateDice : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Heads" 1 False False, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = Flip
    | Toss Bool
    | Dice Int
    | RollDice
    | StopAnimateCoin
    | StopAnimateDice


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Flip ->
            ( model, Random.generate Toss (Random.bool) )

        Toss bool ->
            ( { model | side = boolToSide bool, animateCoin = True }, (pauseThen StopAnimateCoin) )

        RollDice ->
            ( model, Random.generate Dice (Random.int 1 6) )

        Dice num ->
            ( { model | number = num, animateDice = True }, (pauseThen StopAnimateDice) )

        StopAnimateCoin ->
            ( { model | animateCoin = False }, Cmd.none )

        StopAnimateDice ->
            ( { model | animateDice = False }, Cmd.none )


pauseThen : Msg -> Cmd Msg
pauseThen msg =
    Process.sleep (1 * Time.second)
        |> Task.perform (\_ -> msg)


boolToSide : Bool -> String
boolToSide bool =
    if bool then
        "Heads"
    else
        "Tails"


returnCoinFace : Model -> Html Msg
returnCoinFace { side, animateCoin } =
    let
        url =
            if side == "Heads" then
                "https://ucarecdn.com/0086d8fe-fff5-4b91-aad8-d4e8a429e863/heads.png"
            else
                "https://ucarecdn.com/4a0feef6-0c57-4d66-9850-57514ea3da3e/tails.png"
    in
        img
            [ src url
            , onClick Flip
            , style [ ( "width", "200" ), ( "height", "200" ) ]
            , classList [ ( "spin", animateCoin ) ]
            ]
            []


returnDiceFace : Model -> Html Msg
returnDiceFace { number, animateDice } =
    let
        url =
            case number of
                1 ->
                    "https://ucarecdn.com/0dfec8f1-64f3-4c33-9db7-c8d212125e7a/dice1.png"

                2 ->
                    "https://ucarecdn.com/eca65106-59a1-401b-a739-c9223f181b40/dice2.png"

                3 ->
                    "https://ucarecdn.com/a1664b1f-fc28-41a0-b9c1-c846bb05ec23/dice3.png"

                4 ->
                    "https://ucarecdn.com/64ef41cd-288a-43c3-9d65-4be87edaddb9/dice4.png"

                5 ->
                    "https://ucarecdn.com/9a05d88e-8d85-4b73-bb27-81c721f4ffaa/dice5.png"

                6 ->
                    "https://ucarecdn.com/5a0e4b50-6d9e-44bb-8594-dac4b555c9cc/dice6.png"

                _ ->
                    "https://ucarecdn.com/5a0e4b50-6d9e-44bb-8594-dac4b555c9cc/dice6.png"
    in
        img
            [ src url
            , onClick RollDice
            , style [ ( "width", "200" ), ( "height", "200" ) ]
            , classList [ ( "roll", animateDice ) ]
            ]
            []


view : Model -> Html Msg
view model =
    let
        centerStyle =
            [ ( "width", "60%" )
            , ( "margin", "6rem auto" )
            , ( "textAlign", "center" )
            ]
    in
        div []
            [ div [ style centerStyle ] [ returnCoinFace model ]
            , div [ style centerStyle ] [ returnDiceFace model ]
            ]
