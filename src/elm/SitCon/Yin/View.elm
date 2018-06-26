module SitCon.Yin.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Yin.Models as YinModels


root : GlobalModels.GlobalModel -> YinModels.Model -> Html Msg
root global yin =
    div [] [ text "yin" ]
