module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, input, li, p, text, ul)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { count : Int
    , firstName : String
    , questions : List QuestionAnswer
    }


type alias QuestionAnswer =
    { question : String
    , choices : List String
    }


init : Model
init =
    Model 0 "name" initialQuestionAnswer


initialQuestionAnswer : List QuestionAnswer
initialQuestionAnswer =
    [ { question = "What is your favorite color?"
      , choices = [ "Blue", "Yellow", "Red", "Purple" ]
      }
    , { question = "What is your favorite food?"
      , choices = [ "Hamburgers", "Chili", "Pizza" ]
      }
    ]


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
    div [ class "container mt-3" ]
        ([ button [ class "btn btn-secondary", onClick Decrement ] [ text "-" ]
         , div [] [ text (String.fromInt model.count) ]
         , button [ class "btn btn-secondary", onClick Increment ] [ text "+" ]
         , input [ class "list-group mt-3", value model.firstName, onInput FirstName ] []
         , div [] [ text model.firstName ]
         ]
            ++ List.map renderQuestion model.questions
        )



-- View Helpers


renderQuestion : QuestionAnswer -> Html Msg
renderQuestion questionAnswer =
    div []
        [ p [ class "mt-3" ] [ text questionAnswer.question ]
        , ul [ class "list-group" ]
            (List.map (\choice -> li [] [ text choice ]) questionAnswer.choices)
        ]


renderChoice : String -> Html Msg
renderChoice choice =
    li [] [ text choice ]
