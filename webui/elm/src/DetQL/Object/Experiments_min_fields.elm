-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Object.Experiments_min_fields exposing (..)

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


end_time : SelectionSet (Maybe CustomScalarCodecs.Timestamptz) DetQL.Object.Experiments_min_fields
end_time =
    Object.selectionForField "(Maybe CustomScalarCodecs.Timestamptz)" "end_time" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder |> Decode.nullable)


git_commit : SelectionSet (Maybe String) DetQL.Object.Experiments_min_fields
git_commit =
    Object.selectionForField "(Maybe String)" "git_commit" [] (Decode.string |> Decode.nullable)


git_committer : SelectionSet (Maybe String) DetQL.Object.Experiments_min_fields
git_committer =
    Object.selectionForField "(Maybe String)" "git_committer" [] (Decode.string |> Decode.nullable)


git_remote : SelectionSet (Maybe String) DetQL.Object.Experiments_min_fields
git_remote =
    Object.selectionForField "(Maybe String)" "git_remote" [] (Decode.string |> Decode.nullable)


id : SelectionSet (Maybe Int) DetQL.Object.Experiments_min_fields
id =
    Object.selectionForField "(Maybe Int)" "id" [] (Decode.int |> Decode.nullable)


owner_id : SelectionSet (Maybe Int) DetQL.Object.Experiments_min_fields
owner_id =
    Object.selectionForField "(Maybe Int)" "owner_id" [] (Decode.int |> Decode.nullable)


parent_id : SelectionSet (Maybe Int) DetQL.Object.Experiments_min_fields
parent_id =
    Object.selectionForField "(Maybe Int)" "parent_id" [] (Decode.int |> Decode.nullable)


progress : SelectionSet (Maybe CustomScalarCodecs.Float8) DetQL.Object.Experiments_min_fields
progress =
    Object.selectionForField "(Maybe CustomScalarCodecs.Float8)" "progress" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecFloat8 |> .decoder |> Decode.nullable)


start_time : SelectionSet (Maybe CustomScalarCodecs.Timestamptz) DetQL.Object.Experiments_min_fields
start_time =
    Object.selectionForField "(Maybe CustomScalarCodecs.Timestamptz)" "start_time" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder |> Decode.nullable)
