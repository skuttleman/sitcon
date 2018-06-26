module Msgs exposing (..)

import Navigation


type Msg
    = NoOp
    | ChangeLocation String
    | OnLocationChanged Navigation.Location
