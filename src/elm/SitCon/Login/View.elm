module SitCon.Login.View exposing (..)

import Html exposing (Html, a, button, form, input, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onSubmit, onInput)
import SitCon.Global.Models exposing (..)
import SitCon.Login.Models exposing (..)
import Msgs exposing (..)


root : GlobalModel -> LoginModel -> Html Msg
root _ { userForm } =
    form [ onSubmit <| Login userForm ]
        [ input [ onInput (\s -> ChangeUserForm { userForm | email = s }) ] []
        , button [ type_ "submit" ] [ text "Login" ]
        ]
