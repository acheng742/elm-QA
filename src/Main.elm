module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, h3, input, li, p, text, ul)
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
    , selectedChoice : Maybe String
    }


init : Model
init =
    Model 0 "name" initialQuestionAnswer


initialQuestionAnswer : List QuestionAnswer
initialQuestionAnswer =
    [ { question = "What is your favorite color?"
      , choices = [ "Blue", "Yellow", "Red", "Purple" ]
      , selectedChoice = Nothing
      }
    , { question = "What is your favorite food?"
      , choices = [ "Hamburgers", "Chili", "Pizza" ]
      , selectedChoice = Just "Hamburgers"
      }
    , { question = "Where is your dream vacation?"
      , choices = [ "Hawaii", "Fiji", "Virgin Islands" ]
      , selectedChoice = Nothing
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
    div [ class "container my-3" ]
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
        [ h3 [ class "mt-3" ] [ text questionAnswer.question ]
        , ul [ class "list-group" ]
            (List.map (\choice -> renderChoice choice questionAnswer.selectedChoice) questionAnswer.choices)
        ]


renderChoice : String -> Maybe String -> Html Msg
renderChoice choice maybeSelectedChoice =
    let
        maybeActive =
            case maybeSelectedChoice of
                Just selectedChoice ->
                    if selectedChoice == choice then
                        " active"

                    else
                        ""

                Nothing ->
                    ""
    in
    li [ class ("list-group-item list-group-item-action" ++ maybeActive) ] [ text choice ]
