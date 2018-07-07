module SitCon.Global.IO exposing (fetchChannelMessages, fetchEmoji, fetchWorkspaces, fetchUserDetails)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, optional, optionalAt, required, requiredAt)
import Msgs exposing (Msg(..))
import SitCon.Global.Models exposing (Channel, Emoji, UserModel, Workspace)
import Shared.Utils exposing (fetch)
import Uuid


-- HTTP calls


fetchChannelMessages : String -> String -> Cmd Msg
fetchChannelMessages workspace channel =
    fetch ("/api/workspaces/" ++ workspace ++ "/channels/" ++ channel ++ "/messages") emojiListDecoder EmojiOnReceive


fetchEmoji : Cmd Msg
fetchEmoji =
    fetch "/api/emoji" emojiListDecoder EmojiOnReceive


fetchUserDetails : Cmd Msg
fetchUserDetails =
    fetch "/api/user/details" userDetailsDecoder UserDetailsOnReceive


fetchWorkspaces : Cmd Msg
fetchWorkspaces =
    fetch "/api/workspaces" workspaceListDecoder WorkspacesOnReceiveWithChannels



-- Decoders


channelDecoder : Decoder Channel
channelDecoder =
    decode Channel
        |> required "id" Uuid.decoder
        |> required "handle" Decode.string
        |> nullable "purpose" Decode.string
        |> required "private" Decode.bool


emojiDecoder : Decoder Emoji
emojiDecoder =
    decode Emoji
        |> required "id" Uuid.decoder
        |> required "utf_string" Decode.string
        |> required "handles" (Decode.list Decode.string)


emojiListDecoder : Decoder (List Emoji)
emojiListDecoder =
    decode identity
        |> required "emoji" (Decode.list emojiDecoder)


nullable : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
nullable key decoder =
    optional key (Decode.maybe decoder) Nothing


nullableAt : List String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
nullableAt path decoder =
    optionalAt path (Decode.maybe decoder) Nothing


userDetailsDecoder : Decoder UserModel
userDetailsDecoder =
    decode UserModel
        |> requiredAt [ "user", "id" ] Uuid.decoder
        |> requiredAt [ "user", "email" ] Decode.string


workspaceDecoder : Decoder Workspace
workspaceDecoder =
    decode Workspace
        |> required "id" Uuid.decoder
        |> required "handle" Decode.string
        |> nullable "description" Decode.string
        |> required "channels" (Decode.list channelDecoder)


workspaceListDecoder : Decoder (List Workspace)
workspaceListDecoder =
    decode identity
        |> required "workspaces" (Decode.list workspaceDecoder)
