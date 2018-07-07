module SitCon.Channel.View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg(..))
import SitCon.Global.Models exposing (GlobalModel)
import SitCon.Channel.Models exposing (ChannelModel)


root : GlobalModel -> ChannelModel -> Html Msg
root _ _ =
    div [] [ text "channel, foo'" ]
