module SitCon.Global.IO exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, requiredAt)
import Msgs exposing (..)
import Models exposing (..)
import RemoteData
import SitCon.Global.Models as GlobalModels
import Utils exposing (..)
import Uuid


-- HTTP calls


fetchUserDetails : Cmd Msg
fetchUserDetails =
    fetch "/api/user/details" userDetailsDecoder OnUserDetailsReceive



-- Decoders


userDetailsDecoder : Decode.Decoder GlobalModels.UserModel
userDetailsDecoder =
    decode GlobalModels.UserModel
        |> requiredAt [ "user", "id" ] Uuid.decoder
        |> requiredAt [ "user", "firstName" ] Decode.string
        |> requiredAt [ "user", "lastName" ] Decode.string
        |> requiredAt [ "user", "email" ] Decode.string
