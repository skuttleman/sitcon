module SitCon.Global.Models exposing (Channel, Emoji, GlobalModel, Page(..), UserForm, UserModel, Workspace)

import RemoteData exposing (WebData)
import Uuid exposing (Uuid)


type alias Channel =
    { id : Uuid
    , handle : String
    , purpose : Maybe String
    , private : Bool
    }


type alias Emoji =
    { id : Uuid
    , utfString : String
    , handles : List String
    }


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


type alias Workspace =
    { id : Uuid
    , handle : String
    , description : Maybe String
    , channels : List Channel
    }


type alias UserForm =
    { email : String }


type alias UserModel =
    { id : Uuid
    , email : String
    , firstName : String
    , lastName : String
    , avatarUrl : Maybe String
    , handle : String
    }
