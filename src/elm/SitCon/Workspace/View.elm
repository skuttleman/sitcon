module SitCon.Workspace.View exposing (root)

import Html exposing (Html, div, text)
import Msgs exposing (Msg(..))
import SitCon.Global.Models as GlobalModels
import SitCon.Workspace.Models as WorkspaceModels


channelRoot : GlobalModels.GlobalModel -> GlobalModels.Workspace -> GlobalModels.Channel -> Html Msg
channelRoot global workspace channel =
    div [] [ text (toString { workspace | channels = [] }), text (toString channel) ]


workspaceRoot : GlobalModels.GlobalModel -> GlobalModels.Workspace -> Html Msg
workspaceRoot global workspace =
    text (toString { workspace | channels = [] })


root : GlobalModels.GlobalModel -> WorkspaceModels.WorkspaceModel -> Html Msg
root global { active } =
    case active of
        Just ( workspace, Just channel ) ->
            channelRoot global workspace channel

        Just ( workspace, _ ) ->
            workspaceRoot global workspace

        _ ->
            Debug.crash "This is not possible!"
