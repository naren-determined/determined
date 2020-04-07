-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Enum.Searcher_events_select_column exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| select columns of table "searcher\_events"

  - Content - column name
  - Event\_type - column name
  - Experiment\_id - column name
  - Id - column name

-}
type Searcher_events_select_column
    = Content
    | Event_type
    | Experiment_id
    | Id


list : List Searcher_events_select_column
list =
    [ Content, Event_type, Experiment_id, Id ]


decoder : Decoder Searcher_events_select_column
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "content" ->
                        Decode.succeed Content

                    "event_type" ->
                        Decode.succeed Event_type

                    "experiment_id" ->
                        Decode.succeed Experiment_id

                    "id" ->
                        Decode.succeed Id

                    _ ->
                        Decode.fail ("Invalid Searcher_events_select_column type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : Searcher_events_select_column -> String
toString enum =
    case enum of
        Content ->
            "content"

        Event_type ->
            "event_type"

        Experiment_id ->
            "experiment_id"

        Id ->
            "id"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Searcher_events_select_column
fromString enumString =
    case enumString of
        "content" ->
            Just Content

        "event_type" ->
            Just Event_type

        "experiment_id" ->
            Just Experiment_id

        "id" ->
            Just Id

        _ ->
            Nothing
