module MBus.DecodeResult exposing (..)

import Array exposing (Array)
import Hex
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


mbusResultDecoder : Decoder MBusDecodeResult
mbusResultDecoder =
    Decode.succeed MBusDecodeResult
        |> required "identification" Decode.int
        |> required "manufacturer" Decode.int
        |> required "manufacturerName" Decode.string
        |> required "deviceTypeName" Decode.string
        |> required "version" Decode.int
        |> required "deviceType" Decode.int
        |> required "primaryAddress" Decode.int
        |> required "status" Decode.int
        |> required "configWord" Decode.int
        |> required "checksum" Decode.int
        |> required "errorMsg" Decode.string
        |> required "ok" Decode.bool
        |> required "records" (Decode.array recordDecoder)


recordDecoder : Decoder Record
recordDecoder =
    Decode.succeed Record
        |> required "value" Decode.string
        |> required "unit" Decode.string
        |> required "description" Decode.string
        |> required "recordNumber" Decode.int
        |> required "exponent" Decode.string
        |> required "dataType" Decode.string
        |> required "function" Decode.string
        |> required "errorText" Decode.string
        |> required "errorCode" Decode.int
        |> required "storage" Decode.int
        |> required "subunit" Decode.int
        |> required "tariff" Decode.int
        |> required "recordHex" Decode.string


type alias MBusDecodeResult =
    { identification : Int
    , manufacturer : Int
    , manufacturerName : String
    , deviceTypeName : String
    , version : Int
    , deviceType : Int
    , primaryAddress : Int
    , status : Int
    , configWord : Int
    , checksum : Int
    , errorMsg : String
    , ok : Bool
    , records : Array Record
    }


type alias Record =
    { value : String
    , unit : String
    , description : String
    , recordNumber : Int
    , exponent : String
    , dataType : String
    , function : String
    , errorText : String
    , errorCode : Int
    , storage : Int
    , subunit : Int
    , tariff : Int
    , recordHex : String
    }


getSecondaryAddress : MBusDecodeResult -> String
getSecondaryAddress result =
    (String.padLeft 8 '0' <|
        String.fromInt result.identification
    )
        ++ "."
        ++ (String.padLeft 4 '0' <| Hex.toString result.manufacturer)
        ++ "."
        ++ (String.padLeft 2 '0' <| Hex.toString result.version)
        ++ "."
        ++ (String.padLeft 2 '0' <| Hex.toString result.deviceType)
