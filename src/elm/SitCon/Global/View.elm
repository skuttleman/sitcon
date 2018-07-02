module SitCon.Global.View exposing (root)

import Html exposing (Html, div, text)
import SitCon.Global.Models exposing (GlobalModel)
import Msgs exposing (..)


root : GlobalModel -> Html Msg
root global =
    div []
        [ text "home"
        , text (toString global.userDetails)
        , text (toString global.emoji)
        ]
