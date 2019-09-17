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
    Model 0 "name" (initialStatementResponses listOfStatements listOfRepsonses)


listOfRepsonses : List Response
listOfRepsonses =
    [ StronglyAgree, Agree, Neutral, Disagree, StronglyDisagree ]


listOfStatements : List String
listOfStatements =
    [ "My team can clearly articulate their goals"
    , "My team feels recognized for their accomplishments"
    , "All team members have personal development plans and see regular progress towards their goals"
    ]


initialStatementResponses : List String -> List Response -> List StatementResponse
initialStatementResponses statements responses =
    List.map
        (\statement ->
            StatementResponse statement responses Nothing
        )
        statements


type Msg
    = Increment
    | Decrement
    | FirstName String
    | UserSelectedResponse Int Response


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

        UserSelectedResponse index response ->
            let
                responsesToUpdate =
                    model.statementsResponses

                beforeIndex =
                    List.take index responsesToUpdate

                includesIndex =
                    List.drop index responsesToUpdate

                responseToChangeInList =
                    List.take 1 includesIndex

                afterIndex =
                    List.drop 1 includesIndex

                updatedResponseInList =
                    case responseToChangeInList of
                        responseToChange :: _ ->
                            [ { responseToChange | selectedResponse = Just response } ]

                        _ ->
                            []

                updatedResponseList =
                    beforeIndex ++ updatedResponseInList ++ afterIndex
            in
            { model | statementsResponses = updatedResponseList }


view : Model -> Html Msg
view model =
    div [ class "container my-5" ]
        ([ button [ class "btn btn-secondary", onClick Decrement ] [ text "-" ]
         , div [] [ text (String.fromInt model.count) ]
         , button [ class "btn btn-secondary", onClick Increment ] [ text "+" ]
         , input [ class "list-group mt-3", value model.firstName, onInput FirstName ] []
         , div [] [ text model.firstName ]
         ]
            ++ List.indexedMap renderStatement model.statementsResponses
        )



-- View Helpers


renderStatement : Int -> StatementResponse -> Html Msg
renderStatement index statementResponse =
    div []
        [ h3 [ class "mt-3" ] [ text statementResponse.statement ]
        , ul [ class "list-group" ]
            (List.map (\response -> renderResponse index response statementResponse.selectedResponse) statementResponse.responses)
        ]


renderResponse : Int -> Response -> Maybe Response -> Html Msg
renderResponse index response maybeSelectedResponse =
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
    li
        [ class ("list-group-item list-group-item-action" ++ maybeActive)
        , onClick (UserSelectedResponse index response)
        ]
        [ text (showResponse response)
        ]
