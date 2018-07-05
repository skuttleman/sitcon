module Shared.Utils exposing (..)

import Html
import Html.Events exposing (defaultOptions, onWithOptions)
import Http
import Json.Decode as Decode
import RemoteData
import Shared.Models exposing (..)
import Task


call : a -> (a -> b) -> b
call input f =
    f input


fetch : String -> Decode.Decoder t -> (RemoteData.WebData t -> msg) -> Cmd msg
fetch url decoder toMsg =
    Http.get url decoder
        |> RemoteData.sendRequest
        |> Cmd.map toMsg


prevent : msg -> Html.Attribute msg
prevent msg =
    onWithOptions "click"
        { defaultOptions | preventDefault = True }
        (decodeEvent |> Decode.andThen (maybePreventDefault msg))


maybeLift : Maybe (Maybe a) -> Maybe a
maybeLift maybe =
    case maybe of
        Just (Just just) ->
            Just just

        _ ->
            Nothing


maybeOneOf : Maybe a -> Maybe b -> OneOf a b
maybeOneOf maybeA maybeB =
    case ( maybeA, maybeB ) of
        ( Just a, Just b ) ->
            Both a b

        ( Just a, Nothing ) ->
            JustLeft a

        ( Nothing, Just b ) ->
            JustRight b

        ( Nothing, Nothing ) ->
            Neither


whenLeft : OneOf a b -> Maybe a
whenLeft oneOf =
    case oneOf of
        JustLeft a ->
            Just a

        _ ->
            Nothing


whenRight : OneOf a b -> Maybe b
whenRight oneOf =
    case oneOf of
        JustRight b ->
            Just b

        _ ->
            Nothing


whenBoth : OneOf a b -> Maybe ( a, b )
whenBoth oneOf =
    case oneOf of
        Both a b ->
            Just ( a, b )

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


do : msg -> Cmd msg
do msg =
    Task.perform (always msg) (Task.succeed ())


decodeEvent : Decode.Decoder Bool
decodeEvent =
    Decode.map2
        nor
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "metaKey" Decode.bool)


maybePreventDefault : msg -> Bool -> Decode.Decoder msg
maybePreventDefault msg preventDefault =
    case preventDefault of
        True ->
            Decode.succeed msg

        False ->
            Decode.fail "Normal link"


nor : Bool -> Bool -> Bool
nor x y =
    not <| x || y
