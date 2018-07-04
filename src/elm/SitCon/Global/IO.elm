module SitCon.Global.IO exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, optional, optionalAt, required, requiredAt)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import Shared.Utils exposing (..)
import Uuid


-- HTTP calls


fetchUserDetails : Cmd Msg
fetchUserDetails =
    fetch "/api/user/details" userDetailsDecoder UserDetailsOnReceive


fetchEmoji : Cmd Msg
fetchEmoji =
    fetch "/api/emoji" emojiListDecoder EmojiOnReceive


fetchWorkspaces : Cmd Msg
fetchWorkspaces =
    fetch "/api/workspaces" workspaceListDecoder WorkspacesOnReceiveWithChannels



-- Decoders


nullable : String -> Decode.Decoder a -> Decode.Decoder (Maybe a -> b) -> Decode.Decoder b
nullable key decoder =
    optional key (Decode.maybe decoder) Nothing


nullableAt : List String -> Decode.Decoder a -> Decode.Decoder (Maybe a -> b) -> Decode.Decoder b
nullableAt path decoder =
    optionalAt path (Decode.maybe decoder) Nothing


userDetailsDecoder : Decode.Decoder GlobalModels.UserModel
userDetailsDecoder =
    decode GlobalModels.UserModel
        |> requiredAt [ "user", "id" ] Uuid.decoder
        |> requiredAt [ "user", "email" ] Decode.string


emojiListDecoder : Decode.Decoder (List GlobalModels.Emoji)
emojiListDecoder =
    decode identity
        |> required "emoji" (Decode.list emojiDecoder)


emojiDecoder : Decode.Decoder GlobalModels.Emoji
emojiDecoder =
    decode GlobalModels.Emoji
        |> required "id" Uuid.decoder
        |> required "utf_string" Decode.string
        |> required "handles" (Decode.list Decode.string)


workspaceListDecoder : Decode.Decoder (List GlobalModels.Workspace)
workspaceListDecoder =
    decode identity
        |> required "workspaces" (Decode.list workspaceDecoder)


workspaceDecoder : Decode.Decoder GlobalModels.Workspace
workspaceDecoder =
    decode GlobalModels.Workspace
        |> required "id" Uuid.decoder
        |> required "handle" Decode.string
        |> nullable "description" Decode.string
        |> required "channels" (Decode.list channelDecoder)


channelDecoder : Decode.Decoder GlobalModels.Channel
channelDecoder =
    decode GlobalModels.Channel
        |> required "id" Uuid.decoder
        |> required "handle" Decode.string
        |> nullable "purpose" Decode.string
        |> required "private" Decode.bool
