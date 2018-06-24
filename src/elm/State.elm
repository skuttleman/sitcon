module State exposing (init, subs, update)

import Models exposing (..)
import Msgs exposing (..)
import Navigation


init : Navigation.Location -> ( GlobalModel, Cmd Msg )
init location =
    ( { page = locationToPage location }, Cmd.none )


subs : GlobalModel -> Sub Msg
subs _ =
    Sub.none


update : Msg -> GlobalModel -> ( GlobalModel, Cmd Msg )
update msg model =
    ( model, Cmd.none )
