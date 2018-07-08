module SitCon.Workspace.View exposing (root)

import Html exposing (Html, div, img, li, text, ul)
import Html.Attributes exposing (class, src)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Shared.Views exposing (maybe, person, success)
import SitCon.Global.Models exposing (Channel, GlobalModel, Workspace)
import SitCon.Workspace.Models exposing (Entry, WorkspaceModel)
import Time.Iso8601 exposing (fromDateTime)


entryItem : Entry -> Html msg
entryItem { message, creator, createdAt } =
    li [ class "entry-item" ]
        [ div [ class "avatar" ]
            [ img [ src <| Maybe.withDefault "https://picsum.photos/50" creator.avatarUrl ] [] ]
        , div [ class "entry" ]
            [ div [ class "entry-header" ] [ person creator, text (fromDateTime createdAt) ]
            , maybe message (.body >> text >> List.singleton >> div [])
            ]
        ]


entriesRoot : List Entry -> Html msg
entriesRoot entries =
    div [ class "entries-wrapper" ]
        [ ul [ class "entries" ] <|
            List.map
                entryItem
                entries
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
