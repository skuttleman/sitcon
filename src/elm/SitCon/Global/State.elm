module SitCon.Global.State exposing (init, subs, update)

import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import RemoteData exposing (RemoteData(..))
import SitCon.Global.IO exposing (fetchEmoji, fetchWorkspaces, fetchUserDetails)
import SitCon.Global.Models exposing (GlobalModel, Page(..), UserForm)
import SitCon.Global.Utils exposing (locationToPage, pathToPage)
import Shared.Utils exposing (do, succeedOr)


init : Location -> ( GlobalModel, Cmd Msg )
init location =
    ( { page = locationToPage location
      , userDetails = Loading
      , emoji = Loading
      , availableWorkspaces = Loading
      }
    , Cmd.batch [ fetchUserDetails, fetchEmoji, fetchWorkspaces ]
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
                ( { model | page = page }, Navigation.newUrl path )

        LocationOnChanged { pathname } ->
            let
                page =
                    pathToPage pathname
            in
                ( { model | page = page }
                , do <| WorkspacesSetCurrent (succeedOr [] model.availableWorkspaces) page
                )

        Login userForm ->
            ( model, Navigation.load <| loginUrl userForm )

        UserDetailsOnReceive userResponse ->
            case userResponse of
                Success user ->
                    ( { model | userDetails = userResponse }, Cmd.none )

                _ ->
                    ( { model | userDetails = userResponse, page = Just LoginPage }
                    , Navigation.newUrl "/login"
                    )

        EmojiOnReceive emoji ->
            ( { model | emoji = emoji }, Cmd.none )

        WorkspacesOnReceiveWithChannels workspacesResponse ->
            case workspacesResponse of
                Success workspaces ->
                    ( { model | availableWorkspaces = workspacesResponse }
                    , do <| WorkspacesSetCurrent workspaces model.page
                    )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
