module View exposing (root)

import Html exposing (Html, a, button, div, header, span, text)
import Html.Attributes exposing (href)
import Models exposing (AppModel)
import Msgs exposing (..)
import RemoteData
import Router exposing (router)
import Shared.Views exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Login.View as LoginView


workspacesBar : List GlobalModels.Workspace -> Html Msg
workspacesBar workspaces =
    div [] <|
        [ div [] [ text "Workspaces: " ]
        , navList (.handle >> ((++) "/workspaces/")) (.handle >> text) [] workspaces
        ]


channelsBar : List GlobalModels.Channel -> Html Msg
channelsBar channels =
    div [] <| [ div [] [ text "Channels: " ] ] ++ List.map (.handle >> text) channels


navHeader : Html Msg
navHeader =
    header []
        [ text "[ "
        , link "/" [] [ text "to home" ]
        , text " ] [ "
        , a [ href "/auth/logout" ] [ text "log out" ]
        , text " ]"
        ]


root : AppModel -> Html Msg
root ({ global, login, workspace } as model) =
    case global.userDetails of
        RemoteData.Success user ->
            div []
                [ navHeader
                , success workspacesBar global.availableWorkspaces
                , maybe channelsBar (Maybe.map .channels workspace.activeWorkspace)
                , router global.page model
                ]

        RemoteData.Failure _ ->
            LoginView.root global login

        _ ->
            spinner
