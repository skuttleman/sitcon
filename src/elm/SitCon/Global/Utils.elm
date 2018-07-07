module SitCon.Global.Utils exposing (locationToPage, matchers, maybePageToClass, pageToPath, pathToPage, withGlobal)

import Navigation exposing (Location)
import RouteParser exposing (Matcher)
import SitCon.Global.Models exposing (GlobalModel, Page(..))


locationToPage : Location -> Maybe Page
locationToPage =
    .pathname >> pathToPage


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


matchers : List (Matcher Page)
matchers =
    [ RouteParser.static HomePage "/"
    , RouteParser.static LoginPage "/login"
    , RouteParser.dyn1 WorkspacePage "/workspaces/" RouteParser.string ""
    , RouteParser.dyn2 ChannelPage "/workspaces/" RouteParser.string "/channels/" RouteParser.string ""
    , RouteParser.dyn2 ConversationPage "/workspaces/" RouteParser.string "/conversations/" RouteParser.string ""
    ]


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


pathToPage : String -> Maybe Page
pathToPage =
    RouteParser.match matchers


withGlobal : (GlobalModel -> a -> b) -> ({ model | global : GlobalModel } -> a) -> { model | global : GlobalModel } -> b
withGlobal component toPage model =
    component model.global <| toPage model
