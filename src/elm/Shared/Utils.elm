module Shared.Utils exposing (..)

import Html
import Html.Events exposing (onWithOptions)
import Http
import Json.Decode as Decode
import Msgs exposing (..)
import RemoteData
import Task


call : a -> (a -> b) -> b
call input f =
    f input


fetch : String -> Decode.Decoder t -> (RemoteData.WebData t -> Msg) -> Cmd Msg
fetch url decoder toMsg =
    Http.get url decoder
        |> RemoteData.sendRequest
        |> Cmd.map toMsg


prevent : Msg -> Html.Attribute Msg
prevent msg =
    onWithOptions
        "click"
        { stopPropagation = True, preventDefault = True }
        (Decode.succeed msg)


maybeLift : Maybe (Maybe a) -> Maybe a
maybeLift maybe =
    case maybe of
        Just (Just just) ->
            Just just

        _ ->
            Nothing


succeedOr : a -> RemoteData.WebData a -> a
succeedOr value remoteData =
    case remoteData of
        RemoteData.Success result ->
            result

        _ ->
            value


webDataToMaybe : RemoteData.WebData a -> Maybe a
webDataToMaybe remoteData =
    case remoteData of
        RemoteData.Success value ->
            Just value

        _ ->
            Nothing


spyTap : String -> (a -> b) -> a -> a
spyTap label f input =
    let
        _ =
            Debug.log label (f input)
    in
        input


do : Msg -> Cmd Msg
do msg =
    Task.perform (always msg) (Task.succeed ())
