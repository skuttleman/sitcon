module SitCon.Workspace.State exposing (init, subs, update)

import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Shared.Utils exposing (consMaybe, maybeLift, twople, when)
import SitCon.Global.IO exposing (fetchChannelMessages)
import SitCon.Global.Models exposing (Channel, Page(..), Workspace)
import SitCon.Workspace.Models exposing (WorkspaceModel)


init : Location -> ( WorkspaceModel, Cmd Msg )
init location =
    ( { active = Nothing }, Cmd.none )


subs : WorkspaceModel -> Sub Msg
subs _ =
    Sub.none


resolveHandle : List { a | handle : String } -> String -> Maybe { a | handle : String }
resolveHandle workspaces handle =
    workspaces
        |> List.filter (.handle >> (==) handle)
        |> List.head


findWorkspace : List Workspace -> Page -> Maybe Workspace
findWorkspace workspaces page =
    case page of
        WorkspacePage handle ->
            resolveHandle workspaces handle

        ChannelPage handle _ ->
            resolveHandle workspaces handle

        _ ->
            Nothing


findChannel : Maybe Page -> ( Workspace, a ) -> Maybe Channel
findChannel page ( { channels }, _ ) =
    case page of
        Just (ChannelPage _ handle) ->
            resolveHandle channels handle

        _ ->
            Nothing


setCurrentWorkspace : List Workspace -> Maybe Page -> WorkspaceModel -> WorkspaceModel
setCurrentWorkspace workspaces page model =
    { model
        | active =
            page
                |> (Maybe.map (findWorkspace workspaces))
                |> maybeLift
                |> (Maybe.map ((flip twople) Nothing))
    }


setCurrentChannel : Maybe Page -> WorkspaceModel -> WorkspaceModel
setCurrentChannel page model =
    let
        channel =
            model.active
                |> (Maybe.map (findChannel page))
                |> maybeLift
    in
        { model | active = Maybe.map (Tuple.mapSecond <| always channel) model.active }


requireUsers : WorkspaceModel -> WorkspaceModel -> Maybe (Cmd Msg)
requireUsers oldModel newModel =
    Nothing


requireMessages : WorkspaceModel -> WorkspaceModel -> Maybe (Cmd Msg)
requireMessages oldModel newModel =
    when (oldModel.active /= newModel.active) <|
        case newModel.active of
            Just ( workspace, Just channel ) ->
                fetchChannelMessages workspace.handle channel.handle

            _ ->
                Cmd.none


withCmds : WorkspaceModel -> WorkspaceModel -> ( WorkspaceModel, Cmd Msg )
withCmds oldModel newModel =
    []
        |> consMaybe (requireUsers oldModel newModel)
        |> consMaybe (requireMessages oldModel newModel)
        |> Cmd.batch
        |> twople newModel


update : Msg -> WorkspaceModel -> ( WorkspaceModel, Cmd Msg )
update msg model =
    case msg of
        WorkspacesSetCurrent workspaces page ->
            model
                |> setCurrentWorkspace workspaces page
                |> setCurrentChannel page
                |> withCmds model

        _ ->
            ( model, Cmd.none )
