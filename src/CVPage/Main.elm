module CVPage.Main exposing (main)

import Browser
import CVPage.CVPage exposing (..)
import CVPage.Message exposing (Msg(..))
import Html exposing (..)
import List exposing (..)
import Platform exposing (..)
import Shared exposing (Page(..), pageContainer, viewNav)
import String exposing (..)
import Task
import Time


type alias Model =
    { now : Time.Posix
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0), Task.perform CVMsg Time.now )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CVMsg now ->
            ( { model | now = now }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


pageView : Model -> Browser.Document msg
pageView model =
    { title = "Michael Sjögren | Software Developer CV"
    , body =
        [ viewNav PageCV
        , pageContainer
            (CVPage.CVPage.view
                model.now
            )
        ]
    }


view : Model -> Browser.Document msg
view model =
    pageView model
