-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Object.Validation_metrics_stddev_pop_fields exposing (..)

import CustomScalarCodecs
import DetQL.InputObject
import DetQL.Interface
import DetQL.Object
import DetQL.Scalar
import DetQL.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


id : SelectionSet (Maybe Float) DetQL.Object.Validation_metrics_stddev_pop_fields
id =
    Object.selectionForField "(Maybe Float)" "id" [] (Decode.float |> Decode.nullable)


raw : SelectionSet (Maybe Float) DetQL.Object.Validation_metrics_stddev_pop_fields
raw =
    Object.selectionForField "(Maybe Float)" "raw" [] (Decode.float |> Decode.nullable)


signed : SelectionSet (Maybe Float) DetQL.Object.Validation_metrics_stddev_pop_fields
signed =
    Object.selectionForField "(Maybe Float)" "signed" [] (Decode.float |> Decode.nullable)
