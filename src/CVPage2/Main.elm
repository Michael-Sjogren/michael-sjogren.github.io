module CVPage2.Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing ( a, div, h1, nav, p, text)
import Html.Attributes exposing (href)
import Url exposing (Url)


type Page
    = Home
    | About


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, page = pageFromUrl url }
    , Cmd.none
    )


pageFromUrl : Url -> Page
pageFromUrl url =
    case url.path of
        "/about" ->
            About

        _ ->
            Home


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href_ ->
                    ( model, Nav.load href_ )

        UrlChanged url ->
            ( { model | page = pageFromUrl url }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title =
        case model.page of
            Home ->
                "Home"

            About ->
                "About"
    , body =
        [ nav []
            [ a [ href "/" ] [ text "Home" ]
            , text " | "
            , a [ href "/about" ] [ text "About" ]
            ]
        , div []
            (case model.page of
                Home ->
                    [ h1 [] [ text "Home page" ]
                    , p [] [ text "Welcome to the home page." ]
                    ]

                About ->
                    [ h1 [] [ text "About page" ]
                    , p [] [ text "This is the about page." ]
                    ]
            )
        ]
    }
