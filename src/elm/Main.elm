module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Navigation


type alias Model =
    { number : Int }


type Msg =
    NoOp
    | OnLocationChanged Navigation.Location
    | Click


view : Model -> Html Msg
view model =
    div []
        [ text "Counter = ", text (toString model.number)
        , button [ onClick Click ] [ text "Click Me" ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Click ->
      ( { model | number = model.number + 1 }, Cmd.none )
    _ ->
      ( model, Cmd.none )


main : Program Never Model Msg
main =
  Navigation.program OnLocationChanged
    { init = always ( { number = 0 }, Cmd.none )
    , view = view
    , update = update
    , subscriptions = always Sub.none }
