-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module DetQL.Object.Trials exposing (..)

import CustomScalarCodecs
import DetQL.Enum.Checkpoints_select_column
import DetQL.Enum.Steps_select_column
import DetQL.Enum.Trial_logs_select_column
import DetQL.Enum.Validations_select_column
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


{-| An object relationship
-}
checkpoint : SelectionSet decodesTo DetQL.Object.Checkpoints -> SelectionSet (Maybe decodesTo) DetQL.Object.Trials
checkpoint object_ =
    Object.selectionForCompositeField "checkpoint" [] object_ (identity >> Decode.nullable)


type alias CheckpointsOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Checkpoints_select_column.Checkpoints_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Checkpoints_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Checkpoints_bool_exp
    }


{-| An array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
checkpoints : (CheckpointsOptionalArguments -> CheckpointsOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Checkpoints -> SelectionSet (List decodesTo) DetQL.Object.Trials
checkpoints fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Checkpoints_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeCheckpoints_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeCheckpoints_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "checkpoints" optionalArgs object_ (identity >> Decode.list)


type alias CheckpointsAggregateOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Checkpoints_select_column.Checkpoints_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Checkpoints_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Checkpoints_bool_exp
    }


{-| An aggregated array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
checkpoints_aggregate : (CheckpointsAggregateOptionalArguments -> CheckpointsAggregateOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Checkpoints_aggregate -> SelectionSet decodesTo DetQL.Object.Trials
checkpoints_aggregate fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Checkpoints_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeCheckpoints_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeCheckpoints_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "checkpoints_aggregate" optionalArgs object_ identity


end_time : SelectionSet (Maybe CustomScalarCodecs.Timestamptz) DetQL.Object.Trials
end_time =
    Object.selectionForField "(Maybe CustomScalarCodecs.Timestamptz)" "end_time" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder |> Decode.nullable)


{-| An object relationship
-}
experiment : SelectionSet decodesTo DetQL.Object.Experiments -> SelectionSet decodesTo DetQL.Object.Trials
experiment object_ =
    Object.selectionForCompositeField "experiment" [] object_ identity


experiment_id : SelectionSet Int DetQL.Object.Trials
experiment_id =
    Object.selectionForField "Int" "experiment_id" [] Decode.int


type alias HparamsOptionalArguments =
    { path : OptionalArgument String }


{-|

  - path - JSON select path

-}
hparams : (HparamsOptionalArguments -> HparamsOptionalArguments) -> SelectionSet CustomScalarCodecs.Jsonb DetQL.Object.Trials
hparams fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { path = Absent }

        optionalArgs =
            [ Argument.optional "path" filledInOptionals.path Encode.string ]
                |> List.filterMap identity
    in
    Object.selectionForField "CustomScalarCodecs.Jsonb" "hparams" optionalArgs (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecJsonb |> .decoder)


id : SelectionSet Int DetQL.Object.Trials
id =
    Object.selectionForField "Int" "id" [] Decode.int


seed : SelectionSet Int DetQL.Object.Trials
seed =
    Object.selectionForField "Int" "seed" [] Decode.int


start_time : SelectionSet CustomScalarCodecs.Timestamptz DetQL.Object.Trials
start_time =
    Object.selectionForField "CustomScalarCodecs.Timestamptz" "start_time" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder)


state : SelectionSet CustomScalarCodecs.Trial_state DetQL.Object.Trials
state =
    Object.selectionForField "CustomScalarCodecs.Trial_state" "state" [] (CustomScalarCodecs.codecs |> DetQL.Scalar.unwrapCodecs |> .codecTrial_state |> .decoder)


type alias StepsOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Steps_select_column.Steps_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Steps_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Steps_bool_exp
    }


{-| An array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
steps : (StepsOptionalArguments -> StepsOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Steps -> SelectionSet (List decodesTo) DetQL.Object.Trials
steps fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Steps_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeSteps_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeSteps_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "steps" optionalArgs object_ (identity >> Decode.list)


type alias StepsAggregateOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Steps_select_column.Steps_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Steps_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Steps_bool_exp
    }


{-| An aggregated array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
steps_aggregate : (StepsAggregateOptionalArguments -> StepsAggregateOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Steps_aggregate -> SelectionSet decodesTo DetQL.Object.Trials
steps_aggregate fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Steps_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeSteps_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeSteps_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "steps_aggregate" optionalArgs object_ identity


type alias TrialLogsOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Trial_logs_select_column.Trial_logs_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Trial_logs_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Trial_logs_bool_exp
    }


{-| An array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
trial_logs : (TrialLogsOptionalArguments -> TrialLogsOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Trial_logs -> SelectionSet (List decodesTo) DetQL.Object.Trials
trial_logs fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Trial_logs_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeTrial_logs_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeTrial_logs_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "trial_logs" optionalArgs object_ (identity >> Decode.list)


type alias TrialLogsAggregateOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Trial_logs_select_column.Trial_logs_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Trial_logs_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Trial_logs_bool_exp
    }


{-| An aggregated array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
trial_logs_aggregate : (TrialLogsAggregateOptionalArguments -> TrialLogsAggregateOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Trial_logs_aggregate -> SelectionSet decodesTo DetQL.Object.Trials
trial_logs_aggregate fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Trial_logs_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeTrial_logs_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeTrial_logs_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "trial_logs_aggregate" optionalArgs object_ identity


type alias ValidationsOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Validations_select_column.Validations_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Validations_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Validations_bool_exp
    }


{-| An array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
validations : (ValidationsOptionalArguments -> ValidationsOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Validations -> SelectionSet (List decodesTo) DetQL.Object.Trials
validations fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Validations_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeValidations_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeValidations_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "validations" optionalArgs object_ (identity >> Decode.list)


type alias ValidationsAggregateOptionalArguments =
    { distinct_on : OptionalArgument (List DetQL.Enum.Validations_select_column.Validations_select_column)
    , limit : OptionalArgument Int
    , offset : OptionalArgument Int
    , order_by : OptionalArgument (List DetQL.InputObject.Validations_order_by)
    , where_ : OptionalArgument DetQL.InputObject.Validations_bool_exp
    }


{-| An aggregated array relationship

  - distinct\_on - distinct select on columns
  - limit - limit the number of rows returned
  - offset - skip the first n rows. Use only with order\_by
  - order\_by - sort the rows by one or more columns
  - where\_ - filter the rows returned

-}
validations_aggregate : (ValidationsAggregateOptionalArguments -> ValidationsAggregateOptionalArguments) -> SelectionSet decodesTo DetQL.Object.Validations_aggregate -> SelectionSet decodesTo DetQL.Object.Trials
validations_aggregate fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { distinct_on = Absent, limit = Absent, offset = Absent, order_by = Absent, where_ = Absent }

        optionalArgs =
            [ Argument.optional "distinct_on" filledInOptionals.distinct_on (Encode.enum DetQL.Enum.Validations_select_column.toString |> Encode.list), Argument.optional "limit" filledInOptionals.limit Encode.int, Argument.optional "offset" filledInOptionals.offset Encode.int, Argument.optional "order_by" filledInOptionals.order_by (DetQL.InputObject.encodeValidations_order_by |> Encode.list), Argument.optional "where" filledInOptionals.where_ DetQL.InputObject.encodeValidations_bool_exp ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "validations_aggregate" optionalArgs object_ identity


warm_start_checkpoint_id : SelectionSet (Maybe Int) DetQL.Object.Trials
warm_start_checkpoint_id =
    Object.selectionForField "(Maybe Int)" "warm_start_checkpoint_id" [] (Decode.int |> Decode.nullable)
