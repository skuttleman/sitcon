module SitCon.Workspace.Models exposing (WorkspaceModel)

import SitCon.Global.Models exposing (Channel, Workspace)


type alias WorkspaceModel =
    { active : Maybe ( Workspace, Maybe Channel )
    }
