module App exposing (..)

import Html exposing (Html, a, button, div, header, text)
import Html.Attributes exposing (href)
import Models exposing (AppModel)
import Msgs exposing (..)
import Navigation
import RemoteData
import Router exposing (router)
import Shared.Utils exposing (..)
import Shared.Views exposing (..)
import SitCon.Global.State as GlobalState
import SitCon.Login.State as LoginState
import SitCon.Login.View as LoginView
import SitCon.Yang.State as YangState
import SitCon.Yin.State as YinState


init : Navigation.Location -> ( AppModel, Cmd Msg )
init location =
    let
        ( global, globalCmd ) =
            GlobalState.init location

        ( login, loginCmd ) =
            LoginState.init location

        ( yang, yangCmd ) =
            YangState.init global.page

        ( yin, yinCmd ) =
            YinState.init global.page
    in
        ( { global = global
          , yang = yang
          , yin = yin
          , login = login
          }
        , Cmd.batch [ globalCmd, loginCmd, yangCmd, yinCmd ]
        )


view : AppModel -> Html Msg
view model =
    case model.global.userDetails of
        RemoteData.Success user ->
            div []
                [ header []
                    [ text "[ "
                    , link "/" [] [ text "to home" ]
                    , text " ] [ "
                    , link "/yin" [] [ text "to yin" ]
                    , text " ] [ "
                    , link "/yang" [] [ text "to yang" ]
                    , text " ] [ "
                    , a [ href "/auth/logout" ] [ text "log out" ]
                    , text " ]"
                    ]
                , router model.global.page model
                ]

        RemoteData.Failure _ ->
            LoginView.root model.global model.login

        _ ->
            spinner


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    let
        ( global, globalCmd ) =
            GlobalState.update msg model.global

        ( login, loginCmd ) =
            LoginState.update msg model.login

        ( yang, yangCmd ) =
            YangState.update msg model.yang

        ( yin, yinCmd ) =
            YinState.update msg model.yin
    in
        ( { global = global
          , login = login
          , yang = yang
          , yin = yin
          }
        , Cmd.batch [ globalCmd, loginCmd, yangCmd, yinCmd ]
        )


subs : AppModel -> Sub Msg
subs model =
    [ .global >> GlobalState.subs, .yang >> YangState.subs, .yin >> YinState.subs ]
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
