module Models exposing (..)

import Navigation
import SitCon.Yang.Models as YangModels
import SitCon.Yin.Models as YinModels


type alias AppModel =
    { global : GlobalModel
    , yang : YangModels.Model
    , yin : YinModels.Model
    }


type alias GlobalModel =
    { page : Page }


type Page
    = HomePage
    | YinPage
    | YangPage
    | NotFound


pathToPage : String -> Page
pathToPage path =
    case path of
        "/" ->
            HomePage

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

        YinPage ->
            "/yin"

        YangPage ->
            "/yang"

        _ ->
            "/notfound"


locationToPage : Navigation.Location -> Page
locationToPage =
    .pathname >> pathToPage
