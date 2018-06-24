module SitCon.Yang.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import Models
import SitCon.Yang.Models as YangModels


root : Models.GlobalModel -> YangModels.Model -> Html Msg
root global yang =
    div [] [ text "yang" ]
