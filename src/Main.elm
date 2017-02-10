port module Main exposing (main)

import Html exposing (Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (href, src)
import Html.Events exposing (onClick)
import Navigation as Nav
import List.Extra exposing (find)
import WrapidLogo exposing (logo)
import Maybe exposing (andThen)


main : Program Never Model Msg
main =
    Nav.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }



-- MODEL


type alias Model =
    { history : List Nav.Location
    , profiles : List Profile
    , currentImg : Maybe String
    }


type alias Url =
    String


type alias Profile =
    { id : String
    , firstName : String
    , url : Maybe String
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( Model [ location ] [] Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlChange Nav.Location
    | ShowAvatar String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , Cmd.none
            )


        ShowAvatar id ->
            let
                clickedUser =
                    find (\usr -> usr.id == id) model.profiles

                url =
                    andThen .url clickedUser
            in
                ( { model | currentImg = url }
                , Cmd.none
                )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ logo
        , h1 [] [ text "Pages" ]
        , ul [] (List.map viewLink [ "bears", "cats", "dogs", "elephants", "fish" ])
        , h1 [] [ text "History" ]
        , ul [] (List.map viewLocation model.history)
        , h1 [] [ text "Data" ]
        , viewAvatar model.currentImg
        ]


viewLink : String -> Html msg
viewLink name =
    li [] [ a [ href ("#" ++ name) ] [ text name ] ]


viewLocation : Nav.Location -> Html msg
viewLocation location =
    li [] [ text (location.pathname ++ location.hash) ]



viewAvatar : Maybe String -> Html msg
viewAvatar url =
    case url of
        Nothing ->
            text ""

        Just loc ->
            img [ src loc ] []



-- PORTS


-- SUBSCRIPTIONS
