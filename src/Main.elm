module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, href, target)
import List exposing (..)
import Platform exposing (..)
import String exposing (..)
import Task
import Time


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { now : Time.Posix
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model <| Time.millisToPosix 0, Task.perform GetTime Time.now )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GetTime now ->
            ( Model now, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


type Msg
    = NoOp
    | GetTime Time.Posix


calculateElapsedTime : Time.Posix -> Time.Posix -> ( Int, Int )
calculateElapsedTime from to =
    let
        elapsedSeconds =
            (Time.posixToMillis to - Time.posixToMillis from) // 1000

        yearsElapsed =
            elapsedSeconds // 31556926

        months =
            (elapsedSeconds // 2629743) - (yearsElapsed * 12)
    in
    ( yearsElapsed, months )


experienceView : String -> String -> String -> String -> List String -> List (Html Msg)
experienceView projectName projectDescription fromDate toDate technologies =
    [ div [ class "grid gap-4 items-center chapter m-auto max-w-4xl" ]
        [ h3 [ class "text-500 md:text-600 text-stone-600 font-bold font-heading" ] [ text projectName ]
        , div [ class "flex gap-4 items-center" ]
            [ span [ class "font-bold font-heading" ] [ text "From" ]
            , span [ class "text-red-900" ] [ text fromDate ]
            , span [ class "fw-bold" ] [ text "To" ]
            , span [ class "text-red-900" ] [ text toDate ]
            ]
        , div [ class "flex gap-2 flex-wrap items-center" ] <| List.map techLabelView technologies
        , article [ class "leading-[1.86] text-justify max-w-4xl" ]
            [ text projectDescription
            ]
        ]
    ]


projectView : String -> String -> String -> Html Msg
projectView name url description =
    div [ class "grid gap-4 items-center" ]
        [ span []
            [ a [ class "underline text-red-900 font-heading", href url, target "_blank" ] [ text name ]
            ]
        , p []
            [ text description
            ]
        ]



-- label for tech words and programming languages


techLabelView : String -> Html Msg
techLabelView labelText =
    div [ class "text-olive-700 px-2 py-2 bg-mist-100 rounded-lg border border-mist-300" ] [ text labelText ]


intoSectionView : Html Msg
intoSectionView =
    header [ class "grid gap-2 items-center text-justify" ]
        [ h1 [ class "font-heading md:text-800 text-700 font-bold text-olive-800 py-2" ] [ text "Michael Sjögren" ]
        , p [ class "max-w-2xl" ]
            [ text <|
                """
                Hello im michael!
                I currently work at PiiGAB AB as a Software Developer.
                """
            ]
        ]


aboutMeView : Html Msg
aboutMeView =
    div [ class "grid gap-2 items-center text-justify max-w-2xl " ]
        [ p []
            [ text """
                        During my free time, I indulge in personal game development projects
                        and enjoy the challenge of solving puzzles through Advent of Code.
                        I have a genuine interest in open source software, particularly Linux, Godot, and Blender.
                """
            ]
        , p []
            [ text """
                        Additionally, when I'm not engaged in technical pursuits,
                         I find relaxation and enjoyment in watching movies or playing games with friends.
                    """
            ]
        , ul [ class "flex gap-4 items-center text-red-900 underline font-heading" ]
            [ li []
                [ a [ href "https://github.com/Michael-Sjogren", target "_blank" ] [ text "GitHub" ]
                ]
            , li []
                [ a [ href "https://gitlab.com/Michael-Sjogren", target "_blank" ] [ text "GitLab" ]
                ]
            , li []
                [ a [ href "https://linkedin.com/in/Michael-Sjogren", target "_blank" ] [ text "LinkedIn" ]
                ]
            ]
        ]


piigabStartTime : Time.Posix
piigabStartTime =
    Time.millisToPosix 1653897600000


view : Model -> Browser.Document Msg
view model =
    let
        ( years, months ) =
            calculateElapsedTime piigabStartTime model.now

        yearStr =
            if years <= 0 then
                ""

            else if years == 1 then
                "1 Year "

            else
                String.fromInt years ++ " Years"

        monthStr =
            if months <= 0 then
                ""

            else if months == 1 then
                "1 Month"

            else
                String.fromInt months ++ " Months"
    in
    { title = "Michael Sjögren - Software Developer"
    , body =
        [ div [ class "bg-neutral-50 grid gap-4 items-center m-auto p-4 max-w-7xl rounded-md text-olive-900 justify-center" ]
            [ intoSectionView
            , aboutMeView
            , div [ class "grid gap-4 items-center" ]
                [ div [ class "grid gap-4 items-center max-w-4xl justify-center" ]
                    [ h2 [ class "font-bold font-heading text-600 md:text-700 text-olive-800 font-heading" ] [ text "Work" ]
                    , div [] <|
                        experienceView "Software Developer - PiiGAB AB"
                            """
                            I develop and maintain full-stack web applications for the 900T, 900W, 900S, and 900 LTE product lines using Python, JavaScript, HTML, and CSS.
                            I also provide technical support to PiiGAB 900 customers, using tools such as TeamViewer and SSH, along with my Linux expertise.
                            My responsibilities include maintaining C/C++ applications that run on the gateway and generate meter data reports, as well as maintaining the gateway’s SQL database.
                            I also contribute to the development of a JSON-based REST API for the gateway.
                            """
                            "2022-05-30"
                            ("Now, "
                                ++ yearStr
                                ++ (if String.isEmpty yearStr then
                                        " "

                                    else
                                        " and " ++ monthStr
                                   )
                            )
                            [ "Python", "Linux", "C/C++", "Golang", "CSS/Html", "JavaScript", "git", "M-Bus", "C#", "Azure", "Rest API", "Zig" ]
                    , div [] <|
                        experienceView "PHP/Wordpress Web Developer - Strandska"
                            """
                            I took the initiative to design and develop a custom WordPress theme
                            specifically for Strandskas webpage,
                            ensuring that it aligned with their unique needs and branding.
                            Additionally, I have been responsible for the ongoing maintenance
                            and updates of the website to ensure its smooth operation."""
                            "2017"
                            "2018"
                            [ "PHP", "SQL", "Wordpress", "CMS", "CSS/Html", "JavaScript", "JQuery", "Git" ]
                    ]
                , div [ class "grid gap-4 items-center pbe-4 max-w-4xl" ]
                    [ h2 [ class "text-600 md:text-700 text-olive-800 font-bold font-heading" ] [ text "Projects" ]
                    , ul [ class "grid gap-4 items-center" ]
                        [ li [] [ projectView "Robber Run" "https://gruset.itch.io/robber-run" """
                        A game created for the Godot Wild Jam #33.
                        Take on the role of a thief maneuvering through obstacles while gathering coins.""" ]
                        , li [] [ projectView "Dying Ember" "https://gruset.itch.io/dying-ember" """
                        An entry for Ludum Dare 42 game jam,
                        a Godot game crafted within a tight 72-hour timeframe.
                        You play as a ember trying to find its way back to the fiery brazier it calls home.
                        but be careful not to burn out!""" ]
                        ]
                    ]
                ]
            ]
        ]
    }
