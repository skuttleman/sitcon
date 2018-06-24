module Msgs exposing (..)

import Navigation


type Msg
    = NoOp
    | ChangeLocation
    | OnLocationChanged Navigation.Location
