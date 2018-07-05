module Shared.Models exposing (..)


type OneOf a b
    = Both a b
    | JustLeft a
    | JustRight b
    | Neither
