module SitCon.Yang.State exposing (init, subs, update)

import Msgs exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Yang.Models exposing (..)


init : GlobalModels.Page -> ( Model, Cmd Msg )
init page =
    ( { yangThang = "yangThang" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subs : Model -> Sub Msg
subs _ =
    Sub.none
