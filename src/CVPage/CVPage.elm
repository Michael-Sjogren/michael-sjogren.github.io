module CVPage.CVPage exposing (aboutMeView, experienceView, intoSectionView, projectView, techLabelView, view)

import CVPage.Message exposing (Msg(..))
import Html exposing (Html, a, article, div, h3, header, li, p, span, text, ul)
import Html.Attributes exposing (class, href, target)
import Shared exposing (viewPageTitle, viewSectionitle)
import Time


view : Time.Posix -> List (Html msg)
view now =
    let
        tstr =
            getElapsedTimeString now
    in
    [ intoSectionView
    , div [ class "grid gap-4 items-center" ]
        [ div [ class "grid gap-4 items-center max-w-4xl justify-center" ]
            [ viewSectionitle "Work"
            , div [] <|
                experienceView "Software Developer - PiiGAB AB"
                    """
                I develop and maintain full-stack web applications for the 900T, 900W, 900S, and 900 LTE product lines using Python, JavaScript, HTML, and CSS.
                I also provide technical support to PiiGAB 900 customers, using tools such as TeamViewer and SSH, along with my Linux expertise.
                My responsibilities include maintaining C/C++ applications that run on the gateway and generate meter data reports, as well as maintaining the gateway’s SQL database.
                I also contribute to the development of a JSON-based REST API for the gateway.
                """
                    "2022-05-30"
                    ("Now, " ++ tstr)
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
            [ Shared.viewSectionitle "Projects"
            , ul [ class "grid gap-4 items-center" ]
                [ li [] [ projectView "M-Bus decoder" "wired-mbus-decoder.html" """Wired M-Bus decoder, written in Odin and exported to wasm""" ]
                , li [] [ projectView "Robber Run" "https://gruset.itch.io/robber-run" """
            A game created for the Godot Wild Jam #33.
            Take on the role of a thief maneuvering through obstacles while gathering coins.""" ]
                , li [] [ projectView "Dying Ember" "https://gruset.itch.io/dying-ember" """
            An entry for Ludum Dare 42 game jam,
            a Godot game crafted within a tight 72-hour timeframe.
            You play as a ember trying to find its way back to the fiery brazier it calls home.
            but be careful not to burn out!""" ]
                ]
            ]
        , aboutMeView
        ]
    ]


experienceView : String -> String -> String -> String -> List String -> List (Html msg)
experienceView projectName projectDescription fromDate toDate technologies =
    [ div [ class "grid gap-4 items-center chapter m-auto max-w-4xl" ]
        [ h3 [ class "text-500 md:text-600 text-stone-600 font-heading" ] [ text projectName ]
        , div [ class "flex gap-4 items-center text-500" ]
            [ span [ class "font-heading" ] [ text "From" ]
            , span [ class "text-red-900" ] [ text fromDate ]
            , span [ class "font-heading" ] [ text "To" ]
            , span [ class "text-red-900" ] [ text toDate ]
            ]
        , div [ class "flex gap-2 flex-wrap items-center" ] <| List.map techLabelView technologies
        , article [ class "leading-[1.86] text-justify max-w-4xl" ]
            [ text projectDescription
            ]
        ]
    ]


projectView : String -> String -> String -> Html msg
projectView name url description =
    div [ class "grid gap-4 items-center" ]
        [ span []
            [ a [ class "underline text-red-900 font-heading text-500", href url, target "_blank" ] [ text name ]
            ]
        , p []
            [ text description
            ]
        ]



-- label for tech words and programming languages


techLabelView : String -> Html msg
techLabelView labelText =
    div [ class "text-olive-700 px-2 py-2 bg-mist-100 rounded-lg border border-mist-300" ] [ text labelText ]


intoSectionView : Html msg
intoSectionView =
    header [ class "grid gap-2 items-center text-justify" ]
        [ viewPageTitle "Michael Sjögren"
        , p [ class "max-w-2xl" ]
            [ text <|
                """
                Hello my name is Michael Sjögren!
                I currently work at PiiGAB AB as a Software Developer.
                """
            ]
        ]


aboutMeView : Html msg
aboutMeView =
    div [ class "grid gap-2 items-center text-justify max-w-2xl " ]
        [ Shared.viewSectionitle "About"
        , p []
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
        , ul [ class "flex gap-4 items-center text-red-900 underline font-heading text-500" ]
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


getElapsedTimeString : Time.Posix -> String
getElapsedTimeString time =
    let
        ( years, months ) =
            calculateElapsedTime piigabStartTime time

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
    yearStr
        ++ (if String.isEmpty yearStr then
                " "

            else
                " and " ++ monthStr
           )
