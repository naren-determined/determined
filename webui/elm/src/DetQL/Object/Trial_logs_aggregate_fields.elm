-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Object.Trial_logs_aggregate_fields exposing (..)

import CustomScalarCodecs
import DetQL.Enum.Trial_logs_select_column
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


avg : SelectionSet decodesTo DetQL.Object.Trial_logs_avg_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
avg object_ =
    Object.selectionForCompositeField "avg" [] object_ (identity >> Decode.nullable)


type alias CountOptionalArguments =
    { columns : OptionalArgument (List DetQL.Enum.Trial_logs_select_column.Trial_logs_select_column)
    , distinct : OptionalArgument Bool
    }


count : (CountOptionalArguments -> CountOptionalArguments) -> SelectionSet (Maybe Int) DetQL.Object.Trial_logs_aggregate_fields
count fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { columns = Absent, distinct = Absent }

        optionalArgs =
            [ Argument.optional "columns" filledInOptionals.columns (Encode.enum DetQL.Enum.Trial_logs_select_column.toString |> Encode.list), Argument.optional "distinct" filledInOptionals.distinct Encode.bool ]
                |> List.filterMap identity
    in
    Object.selectionForField "(Maybe Int)" "count" optionalArgs (Decode.int |> Decode.nullable)


max : SelectionSet decodesTo DetQL.Object.Trial_logs_max_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
max object_ =
    Object.selectionForCompositeField "max" [] object_ (identity >> Decode.nullable)


min : SelectionSet decodesTo DetQL.Object.Trial_logs_min_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
min object_ =
    Object.selectionForCompositeField "min" [] object_ (identity >> Decode.nullable)


stddev : SelectionSet decodesTo DetQL.Object.Trial_logs_stddev_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
stddev object_ =
    Object.selectionForCompositeField "stddev" [] object_ (identity >> Decode.nullable)


stddev_pop : SelectionSet decodesTo DetQL.Object.Trial_logs_stddev_pop_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
stddev_pop object_ =
    Object.selectionForCompositeField "stddev_pop" [] object_ (identity >> Decode.nullable)


stddev_samp : SelectionSet decodesTo DetQL.Object.Trial_logs_stddev_samp_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
stddev_samp object_ =
    Object.selectionForCompositeField "stddev_samp" [] object_ (identity >> Decode.nullable)


sum : SelectionSet decodesTo DetQL.Object.Trial_logs_sum_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
sum object_ =
    Object.selectionForCompositeField "sum" [] object_ (identity >> Decode.nullable)


var_pop : SelectionSet decodesTo DetQL.Object.Trial_logs_var_pop_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
var_pop object_ =
    Object.selectionForCompositeField "var_pop" [] object_ (identity >> Decode.nullable)


var_samp : SelectionSet decodesTo DetQL.Object.Trial_logs_var_samp_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
var_samp object_ =
    Object.selectionForCompositeField "var_samp" [] object_ (identity >> Decode.nullable)


variance : SelectionSet decodesTo DetQL.Object.Trial_logs_variance_fields -> SelectionSet (Maybe decodesTo) DetQL.Object.Trial_logs_aggregate_fields
variance object_ =
    Object.selectionForCompositeField "variance" [] object_ (identity >> Decode.nullable)
