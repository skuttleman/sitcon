module Models exposing (..)

import SitCon.Global.Models as GlobalModels
import SitCon.Yang.Models as YangModels
import SitCon.Yin.Models as YinModels


type alias AppModel =
    { global : GlobalModels.GlobalModel
    , yang : YangModels.Model
    , yin : YinModels.Model
    }
