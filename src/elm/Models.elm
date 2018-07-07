module Models exposing (AppModel)

import SitCon.Global.Models exposing (GlobalModel)
import SitCon.Login.Models exposing (LoginModel)
import SitCon.Workspace.Models exposing (WorkspaceModel)


type alias AppModel =
    { global : GlobalModel
    , login : LoginModel
    , workspace : WorkspaceModel
    }
