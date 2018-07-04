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
import SitCon.Channel.State as ChannelState
import SitCon.Global.State as GlobalState
import SitCon.Login.State as LoginState
import SitCon.Login.View as LoginView


init : Navigation.Location -> ( AppModel, Cmd Msg )
init location =
    let
        ( global, globalCmd ) =
            GlobalState.init location

        ( login, loginCmd ) =
            LoginState.init location

        ( channel, channelCmd ) =
            ChannelState.init location
    in
        ( { global = global, login = login, channel = channel }
        , Cmd.batch [ globalCmd, loginCmd, channelCmd ]
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

        ( channel, channelCmd ) =
            ChannelState.update msg model.channel
    in
        ( { global = global
          , login = login
          , channel = channel
          }
        , Cmd.batch [ globalCmd, loginCmd, channelCmd ]
        )


subs : AppModel -> Sub Msg
subs model =
    [ .global >> GlobalState.subs
    , .channel >> ChannelState.subs
    ]
        |> List.map (call model)
        |> Sub.batch


main : Program Never AppModel Msg
main =
    Navigation.program LocationOnChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = subs
        }
