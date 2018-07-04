module Msgs exposing (..)

import Navigation
import RemoteData exposing (..)
import SitCon.Global.Models as GlobalModels


type Msg
    = NoOp
    | EmojiOnReceive (WebData (List GlobalModels.Emoji))
    | Login GlobalModels.UserForm
    | LocationChange String
    | LocationOnChanged Navigation.Location
    | UserDetailsOnReceive (WebData GlobalModels.UserModel)
    | UserFormChange GlobalModels.UserForm
