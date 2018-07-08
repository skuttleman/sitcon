module SitCon.Workspace.Models exposing (Entry, Message, WorkspaceModel)

import RemoteData exposing (WebData)
import SitCon.Global.Models exposing (Channel, UserModel, Workspace)
import Uuid exposing (Uuid)
import Time.DateTime exposing (DateTime)


type alias Entry =
    { id : Uuid
    , createdAt : DateTime
    , creator : UserModel
    , message : Maybe Message
    }


type alias Message =
    { id : Uuid
    , body : String
    }


type alias WorkspaceModel =
    { active : Maybe ( Workspace, Maybe Channel )
    , entries : WebData (List Entry)
    }
