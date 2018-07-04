module SitCon.Global.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import RemoteData
import Shared.Utils exposing (..)
import SitCon.Global.Models exposing (..)
import SitCon.Global.IO as GlobalIO


init : Navigation.Location -> ( GlobalModel, Cmd Msg )
init location =
    ( { page = locationToPage location
      , userDetails = RemoteData.Loading
      , emoji = RemoteData.Loading
      , availableWorkspaces = RemoteData.Loading
      }
    , Cmd.batch [ GlobalIO.fetchUserDetails, GlobalIO.fetchEmoji, GlobalIO.fetchWorkspaces ]
    )


subs : GlobalModel -> Sub Msg
subs _ =
    Sub.none


loginUrl : UserForm -> String
loginUrl { email } =
    "/auth/login?email=" ++ email


update : Msg -> GlobalModel -> ( GlobalModel, Cmd Msg )
update msg model =
    case msg of
        LocationChange path ->
            let
                page =
                    pathToPage path
            in
                ( { model | page = page }
                , Cmd.batch [ Navigation.newUrl path, do <| WorkspacesSetCurrent (succeedOr [] model.availableWorkspaces) page ]
                )

        Login userForm ->
            ( model, Navigation.load <| loginUrl userForm )

        UserDetailsOnReceive userResponse ->
            case userResponse of
                RemoteData.Success user ->
                    ( { model | userDetails = userResponse }, Cmd.none )

                _ ->
                    ( { model | userDetails = userResponse, page = Just LoginPage }
                    , Navigation.newUrl "/login"
                    )

        EmojiOnReceive emoji ->
            ( { model | emoji = emoji }, Cmd.none )

        WorkspacesOnReceiveWithChannels workspacesResponse ->
            case workspacesResponse of
                RemoteData.Success workspaces ->
                    ( { model | availableWorkspaces = workspacesResponse }
                    , do <| WorkspacesSetCurrent workspaces model.page
                    )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
