module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, href, style, target)
import List exposing (..)
import Time
import Platform exposing (Task)
import Task
import String exposing (isEmpty)

main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions =  subscriptions
        }


type alias Model = {
    now: Time.Posix
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model <| Time.millisToPosix 0 , Task.perform GetTime Time.now )


update : Msg -> Model -> (Model , Cmd msg)
update msg model =
    case msg of
        GetTime now ->
            (Model now, Cmd.none)
        NoOp ->
            (model, Cmd.none)
type Msg
    = NoOp
    | GetTime Time.Posix


calculateElapsedTime : Time.Posix -> Time.Posix -> (Int,Int)
calculateElapsedTime from to =
    let
        elapsedSeconds = ((Time.posixToMillis to) - (Time.posixToMillis from)) // 1000
        yearsElapsed = (elapsedSeconds // 31556926 )
        months = (elapsedSeconds // 2629743) - (yearsElapsed * 12)
    in
    (yearsElapsed, months)

experienceView : String -> String -> String -> String -> List String -> List (Html Msg)
experienceView projectName projectDescription fromDate toDate technologies =
    [ div [ class "grid chapter" ]
        [ div [ class "flex" ]
            [ span [ class "fw-bold" ] [ text "From" ]
            , span [ class "text-accent" ] [ text fromDate ]
            , span [ class "fw-bold" ] [ text "To" ]
            , span [ class "text-accent" ] [ text toDate ]
            ]
        , h3 [ class "fs-600 ff-heading" ] [ text projectName ]
        , span [ class "fs-400 fw-bold text-accent" ] [ text "Tools i used" ]
        , div [ class "flex article" ] <| List.map techLabelView technologies
        , article [ class "article" ]
            [ text projectDescription
            ]
        ]
    ]


projectView : String -> String -> String -> Html Msg
projectView name url description =
    div [ class "grid" ]
        [ span []
            [ a [ href url, target "_blank" ] [ text name ]
            ]
        , p []
            [ text description
            ]
        ]



-- label for tech words and programming languages


techLabelView : String -> Html Msg
techLabelView labelText =
    span [ class "label" ] [ text labelText ]


intoSectionView : Html Msg
intoSectionView =
    header [ class "grid text-justify" ]
        [ h1 [ class "fs-900 ff-heading" ] [ text "Michael Sjögren" ]
        , p [ class "" ]
            [ text <|
                """
                Currently, I work at PiiGAB AB as a Software Developer,
                where I am mostly maintaining the user interface of the PiiGAB M-Bus 900 units
                but also gaining valuable experience and knowledge in embedded systems.
                """
            ]
        , ul [ class "flex" ]
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


aboutMeView : Html Msg
aboutMeView =
    div [ class "grid text-justify" ]
        [ p []
            [ text """
                        During my free time, I indulge in personal game development projects
                        and enjoy the challenge of solving puzzles through Advent of Code.
                        I have a genuine interest in open source software, particularly Linux, Godot, and Blender,
                        and I actively explore and contribute to these platforms.
                """
            ]
        , p []
            [ text """ 
                        Additionally, when I'm not engaged in technical pursuits,
                         I find relaxation and enjoyment in watching movies or playing games with friends.
                    """
            ]
        ]

piigabStartTime : Time.Posix
piigabStartTime = (Time.millisToPosix 1653897600000)

view : Model -> Browser.Document Msg
view model =
    let
        (years,months) = (calculateElapsedTime piigabStartTime model.now) 
        yearStr = if years <= 0 then
            ""
            else if years == 1 then
                "1 Year "
            else
                (String.fromInt years) ++ " Years"
        
        monthStr = if months <= 0 then
                ""
            else if months == 1 then
                "1 Month"
            else
                (String.fromInt months) ++ " Months" 
    in
    
    { title = "Michael Sjögren - Software Developer"
    , body =
        [ div [ class "grid container" ]
            [ intoSectionView
            , aboutMeView
            , h2 [ class "fs-700 ff-heading" ] [ text "Timeline" ]
            , div [ class "" ]
                [ div []
                    [ div [] <|
                        experienceView "Software Developer - PiiGAB AB"
                            """
                            In my current position at PiiGAB AB, 
                            I have a diverse range of responsibilities that involve the daily maintenance 
                            and improvement of the technical solutions for PiiGAB M-Bus 900 web interface. 
                            Alongside this, I actively engage with the Linux system utilized by these units
                            to solve problems and add new features.
                            
                            One of my notable contributions includes actively participating in the development of 
                            the LTE-module specifically designed for the 900 units. Furthermore, 
                            I have made substantial enhancements to the core web user interface of the system, 
                            resulting in a more user-friendly and efficient experience for the users.
                            """
                            "2022"
                            ("Now, " ++  yearStr ++ if (String.isEmpty yearStr) then " " else " and " ++ monthStr )
                            [ "Python", "Embedded Linux", "Zig", "CSS/Html", "JavaScript", "Git", "M-Bus", "LTE", "C#", "Azure", "Rest API", "Elm", "C++", "Go" ]
                    , div [] <|
                        experienceView ".NET C# Developer - Lexicon YH"
                            """
                            I underwent a 6-month education focused on C# with 
                            .NET Core and Azure, which not only enhanced my skills
                             but also paved the way for my subsequent internship at PiiGAB AB.
                              Following the internship, I was fortunate enough to be hired."""
                            "2021"
                            "2022"
                            [ "C#", "SQL", "Azure", "Enity Framework", "ReactJS", "Git", "Rest API" ]
                    , div [] <|
                        experienceView "Wordpress Web Developer - Strandska"
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
                , div [ class "grid", style "padding-block-end" "4rem" ]
                    [ h2 [ class "fs-700 ff-heading" ] [ text "Projects" ]
                    , ul [ class "grid" ]
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
