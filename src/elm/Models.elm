module Models exposing (..)

import SitCon.Global.Models as GlobalModels
import SitCon.Login.Models as LoginModels
import SitCon.Workspace.Models as WorkspaceModels


type alias AppModel =
    { global : GlobalModels.GlobalModel
    , login : LoginModels.LoginModel
    , workspace : WorkspaceModels.WorkspaceModel
    }
