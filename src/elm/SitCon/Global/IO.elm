module SitCon.Global.IO exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import Shared.Utils exposing (..)
import Uuid


-- HTTP calls


fetchUserDetails : Cmd Msg
fetchUserDetails =
    fetch "/api/user/details" userDetailsDecoder OnUserDetailsReceive


fetchEmoji : Cmd Msg
fetchEmoji =
    fetch "/api/emoji" emojiListDecoder OnEmojiReceive



-- Decoders


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
