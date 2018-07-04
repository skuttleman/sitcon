module SitCon.Workspace.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Workspace.Models as WorkspaceModels
import Shared.Views exposing (..)


root : GlobalModels.GlobalModel -> WorkspaceModels.WorkspaceModel -> Html Msg
root _ { activeWorkspace } =
    maybe
        (always (div [] [ text "Active workspace, bitchez!" ]))
        activeWorkspace
