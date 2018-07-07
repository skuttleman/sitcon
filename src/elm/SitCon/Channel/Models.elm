module SitCon.Channel.Models exposing (ChannelModel)

import SitCon.Global.Models exposing (Channel)


type alias ChannelModel =
    { activeChannel : Maybe Channel
    }
