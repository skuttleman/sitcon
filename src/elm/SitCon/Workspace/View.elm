module SitCon.Workspace.View exposing (root)

import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Shared.Views exposing (success)
import SitCon.Global.Models exposing (Channel, GlobalModel, Workspace)
import SitCon.Workspace.Models exposing (Entry, WorkspaceModel)


entriesRoot : List Entry -> Html msg
entriesRoot entries =
    div [ class "entries-wrapper" ]
        [ ul [ class "entries" ]
            (entries
                |> List.map (.message >> Maybe.map .body)
                |> List.filterMap identity
                |> List.map (text >> List.singleton >> li [ class "entry" ])
            )
        ]


channelRoot : GlobalModel -> Workspace -> Channel -> WebData (List Entry) -> Html Msg
channelRoot global workspace channel entries =
    div []
        [ text (toString { workspace | channels = [] })
        , text (toString channel)
        , success entries entriesRoot
        ]


workspaceRoot : GlobalModel -> Workspace -> Html Msg
workspaceRoot global workspace =
    text (toString { workspace | channels = [] })


root : GlobalModel -> WorkspaceModel -> Html Msg
root global { active, entries } =
    case active of
        Just ( workspace, Just channel ) ->
            channelRoot global workspace channel entries

        Just ( workspace, _ ) ->
            workspaceRoot global workspace

        _ ->
            Debug.crash "This is not possible!"
