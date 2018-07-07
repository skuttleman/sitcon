module Msgs exposing (Msg(..))

import Navigation
import RemoteData exposing (WebData)
import SitCon.Global.Models exposing (Emoji, Page(..), UserForm, UserModel, Workspace)


type Msg
    = NoOp
    | EmojiOnReceive (WebData (List Emoji))
    | Login UserForm
    | LocationChange String
    | LocationOnChanged Navigation.Location
    | UserDetailsOnReceive (WebData UserModel)
    | UserFormChange UserForm
    | WorkspacesOnReceiveWithChannels (WebData (List Workspace))
    | WorkspacesSetCurrent (List Workspace) (Maybe Page)
