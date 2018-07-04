module SitCon.Workspace.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import Shared.Utils exposing (..)
import SitCon.Global.Models as GlobalModels
import SitCon.Workspace.Models exposing (WorkspaceModel)


init : Navigation.Location -> ( WorkspaceModel, Cmd Msg )
init location =
    ( { activeWorkspace = Nothing, activeChannel = Nothing }, Cmd.none )


subs : WorkspaceModel -> Sub Msg
subs _ =
    Sub.none


resolveHandle : List { a | handle : String } -> String -> Maybe { a | handle : String }
resolveHandle workspaces handle =
    workspaces
        |> List.filter (.handle >> (==) handle)
        |> List.head


findWorkspace : List GlobalModels.Workspace -> GlobalModels.Page -> Maybe GlobalModels.Workspace
findWorkspace workspaces page =
    case page of
        GlobalModels.WorkspacePage handle ->
            resolveHandle workspaces handle

        GlobalModels.ChannelPage handle _ ->
            resolveHandle workspaces handle

        _ ->
            Nothing


findChannel : Maybe GlobalModels.Page -> List GlobalModels.Channel -> Maybe GlobalModels.Channel
findChannel page channels =
    case page of
        Just (GlobalModels.ChannelPage _ handle) ->
            resolveHandle channels handle

        _ ->
            Nothing


setCurrentWorkspace : List GlobalModels.Workspace -> Maybe GlobalModels.Page -> WorkspaceModel -> WorkspaceModel
setCurrentWorkspace workspaces page model =
    { model
        | activeWorkspace =
            page
                |> Maybe.map (findWorkspace workspaces)
                |> maybeLift
    }


setCurrentChannel : Maybe GlobalModels.Page -> WorkspaceModel -> WorkspaceModel
setCurrentChannel page model =
    { model
        | activeChannel =
            model.activeWorkspace
                |> Maybe.map (.channels >> findChannel page)
                |> maybeLift
    }


update : Msg -> WorkspaceModel -> ( WorkspaceModel, Cmd Msg )
update msg model =
    case msg of
        WorkspacesSetCurrent workspaces page ->
            ( (setCurrentWorkspace workspaces page >> setCurrentChannel page) model, Cmd.none )

        _ ->
            ( model, Cmd.none )
