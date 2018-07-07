module SitCon.Login.View exposing (root)

import Html exposing (Html, a, button, form, input, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onSubmit, onInput)
import SitCon.Global.Models exposing (GlobalModel)
import SitCon.Login.Models exposing (LoginModel)
import Msgs exposing (Msg(..))


root : GlobalModel -> LoginModel -> Html Msg
root _ { userForm } =
    form [ onSubmit <| Login userForm ]
        [ input [ onInput (\s -> UserFormChange { userForm | email = s }) ] []
        , button [ type_ "submit" ] [ text "Login" ]
        ]
