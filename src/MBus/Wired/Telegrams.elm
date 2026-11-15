module MBus.Wired.Telegrams exposing (intArrayToHex, santizeHexInput, telegramExamples)

import Array exposing (Array)
import Char exposing (isHexDigit)
import Hex


telegramExamples : Array ( Int, String, String )
telegramExamples =
    Array.fromList <|
        [ ( 0, "None", "" )
        , ( 1, "M-Bus example - Water meter", """68 1f 1f 68 08 02 72 78 56 34 12 24 40 01 07 55 00 00 00 03 13 15 31 00 da 02 3b 13 01 8b 60 04 37 18 02 18 16""" )
        ]


santizeHexInput : String -> Array Int
santizeHexInput inputText =
    inputText
        |> String.replace "0x" ""
        |> String.filter isHexDigit
        |> String.toList
        |> chunksOf 2
        |> List.filterMap parseByte
        |> Array.fromList


parseByte : List Char -> Maybe Int
parseByte chars =
    case chars of
        [ hi, lo ] ->
            Maybe.map2 (\h l -> h * 16 + l) (hexVal hi) (hexVal lo)

        _ ->
            Nothing


hexVal : Char -> Maybe Int
hexVal c =
    case c of
        '0' ->
            Just 0

        '1' ->
            Just 1

        '2' ->
            Just 2

        '3' ->
            Just 3

        '4' ->
            Just 4

        '5' ->
            Just 5

        '6' ->
            Just 6

        '7' ->
            Just 7

        '8' ->
            Just 8

        '9' ->
            Just 9

        'a' ->
            Just 10

        'b' ->
            Just 11

        'c' ->
            Just 12

        'd' ->
            Just 13

        'e' ->
            Just 14

        'f' ->
            Just 15

        'A' ->
            Just 10

        'B' ->
            Just 11

        'C' ->
            Just 12

        'D' ->
            Just 13

        'E' ->
            Just 14

        'F' ->
            Just 15

        _ ->
            Nothing


toHexChar : Int -> Char
toHexChar n =
    case n of
        0 ->
            '0'

        1 ->
            '1'

        2 ->
            '2'

        3 ->
            '3'

        4 ->
            '4'

        5 ->
            '5'

        6 ->
            '6'

        7 ->
            '7'

        8 ->
            '8'

        9 ->
            '9'

        10 ->
            'A'

        11 ->
            'B'

        12 ->
            'C'

        13 ->
            'D'

        14 ->
            'E'

        _ ->
            'F'


isHexDigit : Char -> Bool
isHexDigit c =
    hexVal c /= Nothing


chunksOf : Int -> List a -> List (List a)
chunksOf n list =
    if n <= 0 then
        [ list ]

    else
        case List.take n list of
            [] ->
                []

            chunk ->
                chunk :: chunksOf n (List.drop n list)


intArrayToHex : Int -> Array.Array Int -> String
intArrayToHex width intArray =
    intArray
        |> Array.map (\i -> String.padLeft width '0' (Hex.toString i))
        |> Array.toList
        |> String.join " "
