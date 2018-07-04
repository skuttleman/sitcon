module SitCon.Channel.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import SitCon.Channel.Models as ChannelModels exposing (ChannelModel)


init : Navigation.Location -> ( ChannelModel, Cmd Msg )
init _ =
    ( { something = "anything, really" }
    , Cmd.none
    )


subs : ChannelModel -> Sub Msg
subs _ =
    Sub.none


update : Msg -> ChannelModel -> ( ChannelModel, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )
