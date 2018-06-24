module SitCon.Yin.State exposing (init, subs, update)

import Models
import Msgs exposing (..)
import SitCon.Yin.Models exposing (..)


init : Models.Page -> ( Model, Cmd Msg )
init page =
    ( { yinThin = "yinThin" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subs : Model -> Sub Msg
subs _ =
    Sub.none
