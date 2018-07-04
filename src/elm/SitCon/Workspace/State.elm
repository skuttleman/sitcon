module SitCon.Workspace.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import Shared.Utils exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Workspace.Models exposing (WorkspaceModel)


init : Navigation.Location -> ( WorkspaceModel, Cmd Msg )
init location =
    ( { activeWorkspace = Nothing }, Cmd.none )


subs : WorkspaceModel -> Sub Msg
subs _ =
    Sub.none


findWorkspace : List GlobalModels.Workspace -> GlobalModels.Page -> Maybe GlobalModels.Workspace
findWorkspace workspaces page =
    case page of
        GlobalModels.WorkspacePage handle ->
            workspaces
                |> List.filter (.handle >> (==) handle)
                |> List.head

        _ ->
            Nothing


update : Msg -> WorkspaceModel -> ( WorkspaceModel, Cmd Msg )
update msg model =
    case msg of
        WorkspacesSetCurrent workspaces page ->
            ( { model
                | activeWorkspace =
                    page
                        |> Maybe.map (findWorkspace workspaces)
                        |> maybeLift
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
