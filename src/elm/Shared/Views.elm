module Shared.Views exposing (..)

import Html exposing (Html, a, div, li, span, text, ul)
import Html.Attributes exposing (class, href)
import Msgs exposing (Msg(..))
import RemoteData
import Shared.Utils exposing (prevent, webDataToMaybe)


notFound : Html msg
notFound =
    div [] [ text "not found" ]


spinner : Html msg
spinner =
    div [ class "spinner" ] []


link : String -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
link url attributes =
    a (href url :: prevent (LocationChange url) :: attributes)


navList : (a -> String) -> (a -> Html Msg) -> List (Html.Attribute Msg) -> List a -> Html Msg
navList toUrl toChild attributes items =
    ul (class "nav-list" :: attributes) <|
        List.map (\item -> link (toUrl item) [ class "nav-item" ] [ toChild item ]) items


when : Bool -> Html msg -> Html msg
when bool tree =
    if bool then
        tree
    else
        span [] []


possibly : (b -> Maybe a) -> b -> (a -> Html msg) -> Html msg
possibly f input view =
    case f input of
        Just value ->
            view value

        Nothing ->
            span [] []


maybe : Maybe a -> (a -> Html msg) -> Html msg
maybe input =
    possibly (always input) ()


success : RemoteData.WebData a -> (a -> Html msg) -> Html msg
success =
    possibly webDataToMaybe
