module Router exposing (..)

import Html exposing (Html, a, div, text)
import Models exposing (..)
import Msgs exposing (..)
import Shared.Views exposing (..)
import SitCon.Global.Models exposing (..)
import SitCon.Global.View as GlobalView
import SitCon.Login.View as LoginView
import SitCon.Yang.View as YangView
import SitCon.Yin.View as YinView
import Utils exposing (..)


router : Page -> AppModel -> Html Msg
router page =
    case page of
        HomePage ->
            .global >> GlobalView.root

        LoginPage ->
            withGlobal LoginView.root .login

        YinPage ->
            withGlobal YinView.root .yin

        YangPage ->
            withGlobal YangView.root .yang

        _ ->
            always notFound
