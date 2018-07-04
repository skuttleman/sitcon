module Router exposing (router)

import Html exposing (Html, a, div, text)
import Models exposing (..)
import Msgs exposing (..)
import Shared.Views exposing (..)
import SitCon.Global.Models exposing (..)
import SitCon.Global.View as GlobalView
import SitCon.Login.View as LoginView
import SitCon.Workspace.View as WorkspaceView
import Utils exposing (..)


router : Maybe Page -> AppModel -> Html Msg
router page =
    case page of
        Just HomePage ->
            .global >> GlobalView.root

        Just LoginPage ->
            withGlobal LoginView.root .login

        Just (ChannelPage workspace channel) ->
            always notFound

        Just (ConversationPage workspace conversation) ->
            always notFound

        Just (WorkspacePage workspace) ->
            withGlobal WorkspaceView.root .workspace

        Nothing ->
            always notFound
