module Shared.Views exposing (..)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href)
import Msgs exposing (..)
import Shared.Utils exposing (..)


notFound : Html Msg
notFound =
    div [] [ text "not found" ]


spinner : Html Msg
spinner =
    div [ class "spinner" ] [ text "spinner" ]


link : String -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
link url attributes children =
    a (href url :: prevent (LocationChange url) :: attributes) children
