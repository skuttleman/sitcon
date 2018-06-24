module Utils exposing (..)

import Models exposing (..)


withGlobal : (GlobalModel -> a -> b) -> (AppModel -> a) -> AppModel -> b
withGlobal component toPage model =
    component model.global <| toPage model


call : a -> (a -> b) -> b
call input f =
    f input
