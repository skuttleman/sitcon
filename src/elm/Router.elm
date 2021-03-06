module Router exposing (router)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class)
import Models exposing (AppModel)
import Msgs exposing (Msg(..))
import Shared.Views exposing (notFound)
import SitCon.Global.Models exposing (Page(..))
import SitCon.Global.Utils exposing (maybePageToClass, withGlobal)
import SitCon.Global.View as GlobalView
import SitCon.Login.View as LoginView
import SitCon.Workspace.View as WorkspaceView


withPageClass : Maybe Page -> (AppModel -> Html msg) -> AppModel -> Html msg
withPageClass page view model =
    div [ class <| maybePageToClass page, class "page-root" ]
        [ view model ]


router : Maybe Page -> AppModel -> Html Msg
router page =
    withPageClass page <|
        case page of
            Just HomePage ->
                .global >> GlobalView.root

            Just LoginPage ->
                withGlobal LoginView.root .login

            Just (ChannelPage workspaceHandle channelHandle) ->
                withGlobal WorkspaceView.root .workspace

            Just (ConversationPage workspaceHandle conversationHandle) ->
                always notFound

            Just (WorkspacePage workspaceHandle) ->
                withGlobal WorkspaceView.root .workspace

            Nothing ->
                always notFound
