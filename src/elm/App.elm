module App exposing (..)

import Html exposing (Html, button, div, text)
import Models exposing (AppModel)
import Msgs exposing (..)
import Navigation
import Router exposing (router)
import SitCon.Yang.State as YangState
import SitCon.Yin.State as YinState
import State
import Utils exposing (..)


init : Navigation.Location -> ( AppModel, Cmd Msg )
init location =
    let
        ( global, globalCmd ) =
            State.init location

        ( yang, yangCmd ) =
            YangState.init global.page

        ( yin, yinCmd ) =
            YinState.init global.page
    in
        ( { global = global
          , yang = yang
          , yin = yin
          }
        , Cmd.batch [ globalCmd, yangCmd, yinCmd ]
        )


view : AppModel -> Html Msg
view model =
    router model.global.page model


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    let
        ( global, globalCmd ) =
            State.update msg model.global

        ( yang, yangCmd ) =
            YangState.update msg model.yang

        ( yin, yinCmd ) =
            YinState.update msg model.yin
    in
        ( { global = global
          , yang = yang
          , yin = yin
          }
        , Cmd.batch [ globalCmd, yangCmd, yinCmd ]
        )


subs : AppModel -> Sub Msg
subs model =
    [ .global >> State.subs, .yang >> YangState.subs, .yin >> YinState.subs ]
        |> List.map (call model)
        |> Sub.batch


main : Program Never AppModel Msg
main =
    Navigation.program OnLocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = subs
        }
