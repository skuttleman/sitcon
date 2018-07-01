module Utils exposing (..)

import Models exposing (..)
import SitCon.Global.Models exposing (..)


withGlobal : (GlobalModel -> a -> b) -> (AppModel -> a) -> AppModel -> b
withGlobal component toPage model =
    component model.global <| toPage model
