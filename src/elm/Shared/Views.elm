module Shared.Views exposing (..)

import Html exposing (Html, a, div, li, span, text, ul)
import Html.Attributes exposing (class, href)
import Msgs exposing (..)
import RemoteData
import Shared.Utils exposing (..)


notFound : Html Msg
notFound =
    div [] [ text "not found" ]


spinner : Html Msg
spinner =
    div [ class "spinner" ] [ text "spinner" ]


link : String -> List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
link url attributes =
    a (href url :: prevent (LocationChange url) :: attributes)


navList : (a -> String) -> (a -> Html Msg) -> List (Html.Attribute Msg) -> List a -> Html Msg
navList toUrl toChild attributes items =
    ul attributes <| List.map (\item -> link (toUrl item) [] [ toChild item ]) items


when : Bool -> Html Msg -> Html Msg
when bool tree =
    if bool then
        tree
    else
        span [] []


possibly : (a -> Html Msg) -> (b -> Maybe a) -> b -> Html Msg
possibly view f input =
    case f input of
        Just value ->
            view value

        Nothing ->
            span [] []


maybe : (a -> Html Msg) -> Maybe a -> Html Msg
maybe view input =
    possibly view (always input) ()


success : (a -> Html Msg) -> RemoteData.WebData a -> Html Msg
success view =
    possibly view webDataToMaybe
