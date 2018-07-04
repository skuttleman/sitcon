module SitCon.Workspace.Models exposing (..)

import SitCon.Global.Models as GlobalModels


type alias WorkspaceModel =
    { activeWorkspace : Maybe GlobalModels.Workspace
    , activeChannel : Maybe GlobalModels.Channel
    }
