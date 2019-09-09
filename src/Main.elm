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
    , statementsResponses : List StatementResponse
    }


type alias StatementResponse =
    { statement : String
    , responses : List Response
    , selectedResponse : Maybe Response
    }


init : Model
init =
    Model 0 "name" initialStatementResponses


initialStatementResponses : List StatementResponse
initialStatementResponses =
    [ { statement = "My team can clearly articulate their goals"
      , responses = [ StronglyAgree, Agree, Neutral, Disagree, StronglyDisagree ]
      , selectedResponse = Nothing
      }
    , { statement = "My team feels recognized for their accomplishments"
      , responses = [ StronglyAgree, Agree, Neutral, Disagree, StronglyDisagree ]
      , selectedResponse = Just Neutral
      }
    , { statement = "All team members have personal development plans and see regular progress towards their goals"
      , responses = [ StronglyAgree, Agree, Neutral, Disagree, StronglyDisagree ]
      , selectedResponse = Nothing
      }
    ]


type Msg
    = Increment
    | Decrement
    | FirstName String


type Response
    = StronglyAgree
    | Agree
    | Neutral
    | Disagree
    | StronglyDisagree


showResponse : Response -> String
showResponse response =
    case response of
        StronglyAgree ->
            "Strongly Agree"

        Agree ->
            "Agree"

        Neutral ->
            "Neutral"

        Disagree ->
            "Disagree"

        StronglyDisagree ->
            "Strongly Disagree"


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
    div [ class "container my-5" ]
        ([ button [ class "btn btn-secondary", onClick Decrement ] [ text "-" ]
         , div [] [ text (String.fromInt model.count) ]
         , button [ class "btn btn-secondary", onClick Increment ] [ text "+" ]
         , input [ class "list-group mt-3", value model.firstName, onInput FirstName ] []
         , div [] [ text model.firstName ]
         ]
            ++ List.map renderStatement model.statementsResponses
        )



-- View Helpers


renderStatement : StatementResponse -> Html Msg
renderStatement statementResponse =
    div []
        [ h3 [ class "mt-3" ] [ text statementResponse.statement ]
        , ul [ class "list-group" ]
            (List.map (\response -> renderResponse response statementResponse.selectedResponse) statementResponse.responses)
        ]


renderResponse : Response -> Maybe Response -> Html Msg
renderResponse response maybeSelectedResponse =
    let
        maybeActive =
            case maybeSelectedResponse of
                Just selectedResponse ->
                    if selectedResponse == response then
                        " active"

                    else
                        ""

                Nothing ->
                    ""
    in
    li [ class ("list-group-item list-group-item-action" ++ maybeActive) ] [ text (showResponse response) ]
