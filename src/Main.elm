module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, input, li, p, text, ul)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { count : Int
    , firstName : String
    }


type alias SomeNumber =
    Int


type SomeOtherNumber
    = OtherNumber Int


init : Model
init =
    Model 6 "name"


type Msg
    = Increment
    | Decrement
    | FirstName String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            let
                newModel =
                    { model | count = model.count + 1 }
            in
            newModel

        Decrement ->
            let
                newModel =
                    { model | count = model.count - 1 }
            in
            newModel

        FirstName input ->
            let
                updatedModel =
                    { model | firstName = input }
            in
            updatedModel


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , input [ value model.firstName, onInput FirstName ] []
        , div [] [ text model.firstName ]
        , div []
            [ p [] [ text "Please choose an answer" ]
            , ul []
                [ li [] [ text "Answer 1" ]
                ]
            ]
        ]
