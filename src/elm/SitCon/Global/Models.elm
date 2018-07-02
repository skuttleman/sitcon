module SitCon.Global.Models exposing (..)

import Navigation
import RemoteData exposing (WebData)
import Uuid


type alias GlobalModel =
    { page : Page
    , userDetails : WebData UserModel
    , emoji : WebData (List Emoji)
    }


type Page
    = HomePage
    | LoginPage
    | YinPage
    | YangPage
    | NotFound


type alias UserModel =
    { id : Uuid.Uuid
    , firstName : String
    , lastName : String
    , email : String
    }


type alias UserForm =
    { firstName : String
    , lastName : String
    , email : String
    }


type alias Emoji =
    { id : Uuid.Uuid
    , utfString : String
    , handles : List String
    }


pathToPage : String -> Page
pathToPage path =
    case path of
        "/" ->
            HomePage

        "/login" ->
            LoginPage

        "/yin" ->
            YinPage

        "/yang" ->
            YangPage

        _ ->
            NotFound


pageToPath : Page -> String
pageToPath page =
    case page of
        HomePage ->
            "/"

        LoginPage ->
            "/login"

        YinPage ->
            "/yin"

        YangPage ->
            "/yang"

        _ ->
            "/notfound"


locationToPage : Navigation.Location -> Page
locationToPage =
    .pathname >> pathToPage
