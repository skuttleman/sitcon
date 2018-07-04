module SitCon.Global.Models exposing (..)

import Navigation
import RemoteData exposing (WebData)
import RouteParser exposing (..)
import Uuid


type alias GlobalModel =
    { page : Maybe Page
    , userDetails : WebData UserModel
    , emoji : WebData (List Emoji)
    }


type Page
    = HomePage
    | LoginPage
    | ChannelPage String String
    | ConversationPage String String


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


matchers : List (Matcher Page)
matchers =
    [ static HomePage "/"
    , static LoginPage "/login"
    , dyn2 ChannelPage "/workspaces/" string "/channels/" string ""
    , dyn2 ConversationPage "/workspaces/" string "/conversations/" string ""
    ]


pathToPage : String -> Maybe Page
pathToPage =
    match matchers


locationToPage : Navigation.Location -> Maybe Page
locationToPage =
    .pathname >> pathToPage
