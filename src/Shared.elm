module Shared exposing (Page(..), pageContainer, viewLink, viewNav, viewPageTitle, viewSectionitle)

import Html exposing (Html, a, div, h1, h2, li, nav, text, ul)
import Html.Attributes exposing (class, href)


type Page
    = PageCV
    | PageDecoder


pageContainer : List (Html msg) -> Html msg
pageContainer contents =
    div [ class "bg-neutral-50 grid gap-4 items-center m-auto p-4 max-w-7xl rounded-md text-olive-900 justify-center" ] contents


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


viewSectionitle : String -> Html msg
viewSectionitle title =
    h2 [ class "font-heading text-700 text-olive-700" ] [ text title ]


viewPageTitle : String -> Html msg
viewPageTitle title =
    h1 [ class "font-heading text-800 text-olive-700" ] [ text title ]


viewNav : Page -> Html msg
viewNav activePage =
    nav [ class "w-full" ]
        [ ul [ class "w-full flex gap-4 items-center justify-center" ]
            [ viewNavLink PageCV activePage "CV" "/"
            , viewNavLink PageDecoder activePage "M-Bus decoder" "/wired-mbus-decoder.html"
            ]
        ]


viewNavLink : Page -> Page -> String -> String -> Html msg
viewNavLink page currentPage title link =
    let
        isActive =
            page == currentPage

        listyle =
            "font-heading p-4 text-600 w-full text-start "
                ++ (if isActive then
                        "bg-olive-800 text-white"

                    else
                        "text-olive-600 bg-white"
                   )
    in
    li [ class <| "print:hidden " ++ listyle ]
        [ a
            [ class "w-full block"
            , href
                link
            ]
            [ text title ]
        ]
