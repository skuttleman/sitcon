module Router exposing (..)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (href)
import Models exposing (..)
import Msgs exposing (..)
import SitCon.Yin.View as YinView
import SitCon.Yang.View as YangView
import Utils exposing (..)
import View


router : Page -> AppModel -> Html Msg
router page =
    case page of
        HomePage ->
            .global >> View.root

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
    a (href url :: attributes) children
