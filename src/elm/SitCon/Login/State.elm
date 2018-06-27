module SitCon.Login.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import SitCon.Login.Models as LoginModels exposing (LoginModel)


init : Navigation.Location -> ( LoginModel, Cmd Msg )
init _ =
    ( { userForm =
            { firstName = ""
            , lastName = ""
            , email = ""
            }
      }
    , Cmd.none
    )


subs : LoginModel -> Sub Msg
subs _ =
    Sub.none


update : Msg -> LoginModel -> ( LoginModel, Cmd Msg )
update msg model =
    case msg of
        ChangeUserForm userForm ->
            ( { model | userForm = userForm }, Cmd.none )

        _ ->
            ( model, Cmd.none )
