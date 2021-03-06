module App exposing (main)

import Models exposing (AppModel)
import Msgs exposing (Msg(..))
import Navigation exposing (Location, program)
import Shared.Utils exposing (call)
import SitCon.Global.State as GlobalState
import SitCon.Login.State as LoginState
import SitCon.Workspace.State as WorkspaceState
import View


init : Location -> ( AppModel, Cmd Msg )
init location =
    let
        ( global, globalCmd ) =
            GlobalState.init location

        ( login, loginCmd ) =
            LoginState.init location

        ( workspace, workspaceCmd ) =
            WorkspaceState.init location
    in
        ( { global = global, login = login, workspace = workspace }
        , Cmd.batch [ globalCmd, loginCmd, workspaceCmd ]
        )


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg

        ( global, globalCmd ) =
            GlobalState.update msg model.global

        ( login, loginCmd ) =
            LoginState.update msg model.login

        ( workspace, workspaceCmd ) =
            WorkspaceState.update msg model.workspace
    in
        ( { global = global
          , login = login
          , workspace = workspace
          }
        , Cmd.batch [ globalCmd, loginCmd, workspaceCmd ]
        )


subs : AppModel -> Sub Msg
subs model =
    [ .global >> GlobalState.subs, .workspace >> WorkspaceState.subs ]
        |> List.map (call model)
        |> Sub.batch


main : Program Never AppModel Msg
main =
    program LocationOnChanged
        { init = init
        , view = View.root
        , update = update
        , subscriptions = subs
        }
