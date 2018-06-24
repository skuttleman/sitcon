module View exposing (root)

import Html exposing (Html, div, text)
import Models exposing (GlobalModel)
import Msgs exposing (..)


root : GlobalModel -> Html Msg
root global =
    div [] [ text "holmy" ]
