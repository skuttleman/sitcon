module View exposing (root)

import Html exposing (Html, a, button, div, header, span, text)
import Html.Attributes exposing (class, href)
import Models exposing (AppModel)
import Msgs exposing (Msg(..))
import RemoteData
import Router exposing (router)
import Shared.Views exposing (link, maybe, navList, spinner, success)
import SitCon.Global.Models exposing (Channel, Page(..), Workspace)
import SitCon.Global.Utils exposing (pageToPath)
import SitCon.Login.View as LoginView


workspacesBar : List Workspace -> Html Msg
workspacesBar workspaces =
    div [ class "workspaces-wrapper" ]
        [ div [] [ text "Workspaces: " ]
        , navList (.handle >> WorkspacePage >> pageToPath)
            (.handle >> text)
            [ class "workspaces" ]
            workspaces
        ]


channelsBar : ( Workspace, Maybe a ) -> Html Msg
channelsBar ( workspace, _ ) =
    div [ class "channels-wrapper" ]
        [ div []
            [ text "Channels: " ]
        , navList (.handle >> ChannelPage workspace.handle >> pageToPath)
            (.handle >> (++) "# " >> text)
            [ class "channels" ]
            workspace.channels
        ]


navHeader : Html Msg
navHeader =
    header [ class "app-header" ]
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
                , div [ class "main-app" ]
                    [ success global.availableWorkspaces workspacesBar
                    , maybe workspace.active channelsBar
                    , router global.page model
                    ]
                ]

        RemoteData.Failure _ ->
            LoginView.root global login

        _ ->
            spinner
