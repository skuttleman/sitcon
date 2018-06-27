module Router exposing (..)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href)
import Models exposing (..)
import Msgs exposing (..)
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
            .global >> notFound


notFound : GlobalModel -> Html Msg
notFound global =
    div [] [ text "not found" ]


link : String -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
link url attributes children =
    a (href url :: prevent (ChangeLocation url) :: attributes) children
