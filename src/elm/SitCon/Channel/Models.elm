module SitCon.Channel.Models exposing (..)

import SitCon.Global.Models as GlobalModels


type alias ChannelModel =
    { activeChannel : Maybe GlobalModels.Channel
    }
