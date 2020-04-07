-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Object.Experiments_stddev_samp_fields exposing (..)

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


id : SelectionSet (Maybe Float) DetQL.Object.Experiments_stddev_samp_fields
id =
    Object.selectionForField "(Maybe Float)" "id" [] (Decode.float |> Decode.nullable)


owner_id : SelectionSet (Maybe Float) DetQL.Object.Experiments_stddev_samp_fields
owner_id =
    Object.selectionForField "(Maybe Float)" "owner_id" [] (Decode.float |> Decode.nullable)


parent_id : SelectionSet (Maybe Float) DetQL.Object.Experiments_stddev_samp_fields
parent_id =
    Object.selectionForField "(Maybe Float)" "parent_id" [] (Decode.float |> Decode.nullable)


progress : SelectionSet (Maybe Float) DetQL.Object.Experiments_stddev_samp_fields
progress =
    Object.selectionForField "(Maybe Float)" "progress" [] (Decode.float |> Decode.nullable)
