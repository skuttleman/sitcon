module Msgs exposing (..)

import Navigation
import RemoteData exposing (..)
import SitCon.Global.Models as GlobalModels


type Msg
    = NoOp
    | Login GlobalModels.UserForm
    | ChangeLocation String
    | OnLocationChanged Navigation.Location
    | OnUserDetailsReceive (WebData GlobalModels.UserModel)
    | OnEmojiReceive (WebData (List GlobalModels.Emoji))
    | ChangeUserForm GlobalModels.UserForm
