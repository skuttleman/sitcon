module SitCon.Channel.State exposing (init, subs, update)

import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import SitCon.Channel.Models as ChannelModels exposing (ChannelModel)


init : Location -> ( ChannelModel, Cmd Msg )
init _ =
    ( { activeChannel = Nothing }
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
