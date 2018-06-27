module Models exposing (..)

import SitCon.Global.Models as GlobalModels
import SitCon.Login.Models as LoginModels
import SitCon.Yang.Models as YangModels
import SitCon.Yin.Models as YinModels


type alias AppModel =
    { global : GlobalModels.GlobalModel
    , login : LoginModels.LoginModel
    , yang : YangModels.Model
    , yin : YinModels.Model
    }
