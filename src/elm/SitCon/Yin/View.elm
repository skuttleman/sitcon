module SitCon.Yin.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import Models
import SitCon.Yin.Models as YinModels


root : Models.GlobalModel -> YinModels.Model -> Html Msg
root global yin =
    div [] [ text "yin" ]
