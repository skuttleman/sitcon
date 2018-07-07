module Shared.Utils
    exposing
        ( (/||)
        , call
        , consMaybe
        , decodeEvent
        , do
        , fetch
        , maybeBool
        , maybeLift
        , maybePreventDefault
        , prevent
        , spyTap
        , succeedOr
        , twople
        , webDataToMaybe
        , when
        )

import Html exposing (Attribute)
import Html.Events exposing (defaultOptions, onWithOptions)
import Http
import Json.Decode as Decode exposing (Decoder)
import RemoteData exposing (RemoteData(..), WebData, sendRequest)
import Task exposing (perform, succeed)


(/||) : Bool -> Bool -> Bool
(/||) x y =
    not <| x || y


call : a -> (a -> b) -> b
call input f =
    f input


consMaybe : Maybe a -> List a -> List a
consMaybe maybe list =
    case maybe of
        Just value ->
            value :: list

        Nothing ->
            list


decodeEvent : Decoder Bool
decodeEvent =
    Decode.map2 (/||) (Decode.field "ctrlKey" Decode.bool) (Decode.field "metaKey" Decode.bool)


do : msg -> Cmd msg
do msg =
    perform (always msg) (succeed ())


fetch : String -> Decoder t -> (WebData t -> msg) -> Cmd msg
fetch url decoder toMsg =
    Http.get url decoder
        |> sendRequest
        |> Cmd.map toMsg


maybeBool : Maybe a -> Bool
maybeBool maybe =
    case maybe of
        Just _ ->
            True

        Nothing ->
            False


maybeLift : Maybe (Maybe a) -> Maybe a
maybeLift maybe =
    case maybe of
        Just (Just just) ->
            Just just

        _ ->
            Nothing


maybePreventDefault : msg -> Bool -> Decoder msg
maybePreventDefault msg preventDefault =
    case preventDefault of
        True ->
            Decode.succeed msg

        False ->
            Decode.fail "Normal link"


prevent : msg -> Attribute msg
prevent msg =
    onWithOptions "click"
        { defaultOptions | preventDefault = True }
        (decodeEvent |> Decode.andThen (maybePreventDefault msg))


spyTap : String -> (a -> b) -> a -> a
spyTap label f input =
    let
        _ =
            Debug.log label (f input)
    in
        input


succeedOr : a -> WebData a -> a
succeedOr value remoteData =
    case remoteData of
        Success result ->
            result

        _ ->
            value


twople : a -> b -> ( a, b )
twople a b =
    ( a, b )


webDataToMaybe : WebData a -> Maybe a
webDataToMaybe remoteData =
    case remoteData of
        Success value ->
            Just value

        _ ->
            Nothing


when : Bool -> a -> Maybe a
when condition value =
    if condition then
        Just value
    else
        Nothing
