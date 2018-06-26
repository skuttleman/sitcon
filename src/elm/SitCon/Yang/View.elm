module SitCon.Yang.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Yang.Models as YangModels


root : GlobalModels.GlobalModel -> YangModels.Model -> Html Msg
root global yang =
    div [] [ text "yang" ]
