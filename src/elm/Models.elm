module Models exposing (..)

import SitCon.Channel.Models as ChannelModels
import SitCon.Global.Models as GlobalModels
import SitCon.Login.Models as LoginModels


type alias AppModel =
    { global : GlobalModels.GlobalModel
    , login : LoginModels.LoginModel
    , channel : ChannelModels.ChannelModel
    }
