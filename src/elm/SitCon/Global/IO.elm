module SitCon.Global.IO exposing (fetchChannelMessages, fetchEmoji, fetchWorkspaces, fetchUserDetails)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, optional, optionalAt, required, requiredAt)
import Msgs exposing (Msg(..))
import SitCon.Global.Models exposing (Channel, Emoji, UserModel, Workspace)
import SitCon.Workspace.Models exposing (Entry, Message)
import Shared.Utils exposing (fetch)
import Uuid


-- HTTP calls


fetchChannelMessages : String -> String -> Cmd Msg
fetchChannelMessages workspace channel =
    fetch ("/api/workspaces/" ++ workspace ++ "/channels/" ++ channel ++ "/messages")
        (identityDecoder "entries" <| Decode.list entryDecoder)
        MessagesOnRecieve


fetchEmoji : Cmd Msg
fetchEmoji =
    fetch "/api/emoji"
        (identityDecoder "emoji" <| Decode.list emojiDecoder)
        EmojiOnReceive


fetchUserDetails : Cmd Msg
fetchUserDetails =
    fetch "/api/user/details"
        (identityDecoder "user" userDecoder)
        UserDetailsOnReceive


fetchWorkspaces : Cmd Msg
fetchWorkspaces =
    fetch "/api/workspaces"
        (identityDecoder "workspaces" <| Decode.list workspaceDecoder)
        WorkspacesOnReceiveWithChannels



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
        |> required "handles" (Decode.list <| identityDecoder "handle" Decode.string)


entryDecoder : Decoder Entry
entryDecoder =
    decode Entry
        |> required "id" Uuid.decoder
        |> required "created_at" Decode.string
        |> required "creator" userDecoder
        |> nullable "message" messageDecoder


messageDecoder : Decoder Message
messageDecoder =
    decode Message
        |> required "id" Uuid.decoder
        |> required "body" Decode.string


identityDecoder : String -> Decoder a -> Decoder a
identityDecoder key decoder =
    decode identity
        |> required key decoder


nullable : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
nullable key decoder =
    optional key (Decode.maybe decoder) Nothing


nullableAt : List String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
nullableAt path decoder =
    optionalAt path (Decode.maybe decoder) Nothing


userDecoder : Decoder UserModel
userDecoder =
    decode UserModel
        |> required "id" Uuid.decoder
        |> required "email" Decode.string
        |> required "first_name" Decode.string
        |> required "last_name" Decode.string
        |> nullable "avatar_url" Decode.string
        |> required "handle" Decode.string


workspaceDecoder : Decoder Workspace
workspaceDecoder =
    decode Workspace
        |> required "id" Uuid.decoder
        |> required "handle" Decode.string
        |> nullable "description" Decode.string
        |> required "channels" (Decode.list channelDecoder)
