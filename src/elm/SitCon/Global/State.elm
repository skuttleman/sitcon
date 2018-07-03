module SitCon.Global.State exposing (init, subs, update)

import Msgs exposing (..)
import Navigation
import RemoteData
import SitCon.Global.Models exposing (..)
import SitCon.Global.IO as GlobalIO


init : Navigation.Location -> ( GlobalModel, Cmd Msg )
init location =
    ( { page = locationToPage location
      , userDetails = RemoteData.Loading
      , emoji = RemoteData.Loading
      }
    , Cmd.batch [ GlobalIO.fetchUserDetails, GlobalIO.fetchEmoji ]
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
        ChangeLocation path ->
            ( { model | page = pathToPage path }, Navigation.newUrl path )

        Login userForm ->
            ( model, Navigation.load <| loginUrl userForm )

        OnUserDetailsReceive userResponse ->
            case userResponse of
                RemoteData.Success user ->
                    ( { model | userDetails = userResponse }, Cmd.none )

                _ ->
                    ( { model | userDetails = userResponse, page = LoginPage }
                    , Navigation.newUrl "/login"
                    )

        OnEmojiReceive emoji ->
            ( { model | emoji = emoji }, Cmd.none )

        _ ->
            ( model, Cmd.none )
