module CVPage.Message exposing (Msg(..))

import Time


type Msg
    = NoOp
    | CVMsg Time.Posix
