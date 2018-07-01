module Shared.Utils exposing (..)

import Html
import Html.Events exposing (onWithOptions)
import Http
import Json.Decode as Decode
import Msgs exposing (..)
import RemoteData


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
