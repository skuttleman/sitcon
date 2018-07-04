module SitCon.Channel.View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onSubmit, onInput)
import Msgs exposing (..)
import SitCon.Global.Models exposing (..)
import SitCon.Channel.Models exposing (..)


root : GlobalModel -> ChannelModel -> Html Msg
root _ _ =
    div [] [ text "channel, foo'" ]
