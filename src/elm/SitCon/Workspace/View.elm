module SitCon.Workspace.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Workspace.Models as WorkspaceModels
import Shared.Models exposing (..)
import Shared.Utils exposing (..)


channelRoot : GlobalModels.GlobalModel -> GlobalModels.Workspace -> GlobalModels.Channel -> Html Msg
channelRoot global workspace channel =
    div [] [ text (toString { workspace | channels = [] }), text (toString channel) ]


workspaceRoot : GlobalModels.GlobalModel -> GlobalModels.Workspace -> Html Msg
workspaceRoot global workspace =
    text (toString { workspace | channels = [] })


root : GlobalModels.GlobalModel -> WorkspaceModels.WorkspaceModel -> Html Msg
root global { activeWorkspace, activeChannel } =
    case maybeOneOf activeWorkspace activeChannel of
        Both workspace channel ->
            channelRoot global workspace channel

        JustLeft workspace ->
            workspaceRoot global workspace

        _ ->
            Debug.crash "This is not possible!"
