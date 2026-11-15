port module MBus.Wired.Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (class, for, id, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (decodeString)
import MBus.DecodeResult exposing (MBusDecodeResult, getSecondaryAddress, mbusResultDecoder)
import MBus.Wired.Telegrams exposing (intArrayToHex, santizeHexInput, telegramExamples)
import Maybe exposing (withDefault)
import Platform.Cmd as Cmd
import Shared exposing (Page(..), pageContainer, viewNav)


type Msg
    = GotDecodeResult (Maybe String)
    | TelegramInputChanged String
    | SendDecodeRequest (Array Int)
    | SelectedMBusExample String
    | DecodeTelegram
    | NoOp


type alias Model =
    { result : Maybe MBusDecodeResult
    , input : String
    }


port decodeResult : (Maybe String -> msg) -> Sub msg


port sendDecodeRequest : Array Int -> Cmd msg


init : {} -> ( Model, Cmd Msg )
init _ =
    ( { result = Nothing, input = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SendDecodeRequest bytes ->
            ( model, sendDecodeRequest bytes )

        GotDecodeResult r ->
            case r of
                Just str ->
                    case decodeString mbusResultDecoder str of
                        Result.Ok res ->
                            ( { model | result = Just res }, Cmd.none )

                        Result.Err _ ->
                            ( { model | result = Nothing }, Cmd.none )

                Nothing ->
                    ( { model | result = Nothing }, Cmd.none )

        TelegramInputChanged req ->
            ( { model | input = req }, Cmd.none )

        DecodeTelegram ->
            let
                bytes =
                    santizeHexInput model.input
            in
            ( { model | input = intArrayToHex 2 bytes }, Cmd.batch [ sendDecodeRequest bytes ] )

        SelectedMBusExample selected ->
            case Array.get (withDefault 0 (String.toInt selected)) telegramExamples of
                Just ( _, _, tlg ) ->
                    let
                        bytes =
                            santizeHexInput tlg
                    in
                    ( { model | input = tlg }, sendDecodeRequest bytes )

                Nothing ->
                    ( { model | input = "" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ decodeResult GotDecodeResult
        ]


view : Model -> Browser.Document Msg
view model =
    let
        options : List (Html msg)
        options =
            Array.toList
                (Array.map
                    (\( oid, title, _ ) ->
                        option [ value <| String.fromInt oid ] [ text title ]
                    )
                    telegramExamples
                )
    in
    { title = "Wired M-Bus decoder"
    , body =
        [ viewNav PageDecoder
        , pageContainer <|
            [ div [ class "grid gap-10 items-center w-full text-left" ] <|
                [ Shared.viewSectionitle "M-Bus Decoder"
                , div [ class "flex gap-4 items-center justify-between" ]
                    [ label [ for "exampleTelegrams" ] [ text "Example telegrams" ]
                    , select [ id "exampleTelegrams", class "bg-white border border-gray-300 rounded-lg py-2 px-1", onInput SelectedMBusExample ]
                        options
                    ]
                ]
            , textarea [ id "telegramInput", class "font-mono bg-white block w-full px-3 py-2 border border-gray-300 rounded-lg", value model.input, onInput TelegramInputChanged ] []
            , button [ onClick DecodeTelegram, class "bg-olive-700 text-white p-4 rounded-lg font-heading text-3xl cursor-pointer" ] [ text "Decode" ]
            , div [ class "text-black" ] [ renderDecodeTable model ]
            ]
        ]
    }


viewDecodeHeaderResult : Model -> Html msg
viewDecodeHeaderResult model =
    case model.result of
        Just result ->
            div []
                [ div []
                    [ text <| getSecondaryAddress result ]
                , div []
                    [ text <| result.manufacturerName ]
                , div [] [ text result.deviceTypeName ]
                ]

        Nothing ->
            div [] [ text "" ]


renderDecodeTable : Model -> Html Msg
renderDecodeTable model =
    div [ class "grid gap-4 items-center" ]
        [ viewDecodeHeaderResult model
        , case model.result of
            Just result ->
                table [ class "table-full overflow-x-auto text-right m-auto border-collapse rounded-lg border border-gray-300" ]
                    [ tr []
                        [ th [ class "p-4" ] [ text "Name" ]
                        , th [ class "p-4" ] [ text "Storage" ]
                        , th [ class "p-4" ] [ text "Value" ]
                        , th [ class "p-4" ] [ text "Unit" ]
                        , th [ class "p-4" ] [ text "Function" ]
                        , th [ class "p-4" ] [ text "Type" ]
                        , th [ class "p-4" ] [ text "Hex" ]
                        ]
                    , tbody [] <|
                        Array.toList <|
                            Array.map
                                (\item ->
                                    tr [ class "odd:bg-gray-100 hover:bg-blue-100 text-right text-neutral-800 font-normal border border-gray-300" ]
                                        [ td [ class "p-4 border border-gray-300" ] [ text item.description ]
                                        , td [ class "p-4 border border-gray-300" ] [ text <| String.fromInt item.storage ]
                                        , td [ class "p-4 border border-gray-300" ] [ text item.value ]
                                        , td [ class "p-4 border border-gray-300" ] [ text item.unit ]
                                        , td [ class "p-4 border border-gray-300" ] [ text item.function ]
                                        , td [ class "p-4 border border-gray-300" ] [ text item.dataType ]
                                        , td [ class "p-4 border border-gray-300 font-mono" ] [ text item.recordHex ]
                                        ]
                                )
                                result.records
                    ]

            Nothing ->
                div [] [ text "Nothing to decode" ]
        ]


main : Program {} Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
