module SitCon.Login.View exposing (..)

import Html exposing (Html, a, button, div, input, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick, onInput)
import SitCon.Global.Models exposing (..)
import SitCon.Login.Models exposing (..)
import Msgs exposing (..)


root : GlobalModel -> LoginModel -> Html Msg
root _ { userForm } =
    div []
        [ input [ onInput (\s -> ChangeUserForm { userForm | firstName = s }) ] []
        , input [ onInput (\s -> ChangeUserForm { userForm | lastName = s }) ] []
        , input [ onInput (\s -> ChangeUserForm { userForm | email = s }) ] []
        , button [ onClick <| Login userForm ] [ text "Login" ]
        ]
