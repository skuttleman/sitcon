module Utils exposing (..)

import Html
import Html.Events exposing (onWithOptions)
import Http
import Json.Decode as Decode
import Models exposing (..)
import Msgs exposing (..)
import RemoteData
import SitCon.Global.Models exposing (..)
import SitCon.Login.Models exposing (..)


withGlobal : (GlobalModel -> a -> b) -> (AppModel -> a) -> AppModel -> b
withGlobal component toPage model =
    component model.global <| toPage model


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
