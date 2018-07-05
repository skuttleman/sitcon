module SitCon.Global.Models exposing (..)

import Navigation
import RemoteData exposing (WebData)
import RouteParser exposing (..)
import Uuid


type alias GlobalModel =
    { page : Maybe Page
    , userDetails : WebData UserModel
    , emoji : WebData (List Emoji)
    , availableWorkspaces : WebData (List Workspace)
    }


type Page
    = HomePage
    | LoginPage
    | ChannelPage String String
    | ConversationPage String String
    | WorkspacePage String


type alias UserModel =
    { id : Uuid.Uuid
    , email : String
    }


type alias UserForm =
    { email : String }


type alias Emoji =
    { id : Uuid.Uuid
    , utfString : String
    , handles : List String
    }


type alias Workspace =
    { id : Uuid.Uuid
    , handle : String
    , description : Maybe String
    , channels : List Channel
    }


type alias Channel =
    { id : Uuid.Uuid
    , handle : String
    , purpose : Maybe String
    , private : Bool
    }


matchers : List (Matcher Page)
matchers =
    [ static HomePage "/"
    , static LoginPage "/login"
    , dyn1 WorkspacePage "/workspaces/" string ""
    , dyn2 ChannelPage "/workspaces/" string "/channels/" string ""
    , dyn2 ConversationPage "/workspaces/" string "/conversations/" string ""
    ]


pathToPage : String -> Maybe Page
pathToPage =
    match matchers


locationToPage : Navigation.Location -> Maybe Page
locationToPage =
    .pathname >> pathToPage


pageToPath : Page -> String
pageToPath page =
    case page of
        HomePage ->
            "/"

        LoginPage ->
            "/login"

        ChannelPage workspaceHandle channelHandle ->
            "/workspaces/" ++ workspaceHandle ++ "/channels/" ++ channelHandle

        ConversationPage workspaceHandle conversationId ->
            "/workspaces/" ++ workspaceHandle ++ "/conversations/" ++ conversationId

        WorkspacePage workspaceHandle ->
            "/workspaces/" ++ workspaceHandle


maybePageToClass : Maybe Page -> String
maybePageToClass page =
    case page of
        Just HomePage ->
            "home-page"

        Just LoginPage ->
            "login-page"

        Just (ChannelPage _ _) ->
            "channel-page"

        Just (ConversationPage _ _) ->
            "conversation-page"

        Just (WorkspacePage _) ->
            "workspace-page"

        Nothing ->
            "not-found"
