module SitCon.Global.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import SitCon.Global.Models exposing (..)


init : Navigation.Location -> ( GlobalModel, Cmd Msg )
init location =
    ( { page = locationToPage location }, Cmd.none )


subs : GlobalModel -> Sub Msg
subs _ =
    Sub.none


update : Msg -> GlobalModel -> ( GlobalModel, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( { model | page = pathToPage path }, Navigation.newUrl path )

        _ ->
            ( model, Cmd.none )
