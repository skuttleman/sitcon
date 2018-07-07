module Msgs exposing (Msg(..))

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import SitCon.Global.Models exposing (Emoji, Page(..), UserForm, UserModel, Workspace)
import SitCon.Workspace.Models exposing (Entry)


type Msg
    = NoOp
    | EmojiOnReceive (WebData (List Emoji))
    | Login UserForm
    | LocationChange String
    | LocationOnChanged Location
    | MessagesOnRecieve (WebData (List Entry))
    | UserDetailsOnReceive (WebData UserModel)
    | UserFormChange UserForm
    | WorkspacesOnReceiveWithChannels (WebData (List Workspace))
    | WorkspacesSetCurrent (List Workspace) (Maybe Page)
