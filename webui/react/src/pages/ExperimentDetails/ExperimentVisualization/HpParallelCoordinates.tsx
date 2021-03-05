import { Alert, Select } from 'antd';
import { SelectValue } from 'antd/es/select';
import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import Message, { MessageType } from 'components/Message';
import MetricSelectFilter from 'components/MetricSelectFilter';
import MultiSelect from 'components/MultiSelect';
import ParallelCoordinates, {
  Constraint, Dimension, DimensionType, dimensionTypeMap,
} from 'components/ParallelCoordinates';
import ResponsiveFilters from 'components/ResponsiveFilters';
import Section from 'components/Section';
import SelectFilter from 'components/SelectFilter';
import Spinner from 'components/Spinner';
import { V1TrialsSnapshotResponse } from 'services/api-ts-sdk';
import { detApi } from 'services/apiConfig';
import { consumeStream } from 'services/utils';
import {
  ExperimentBase, ExperimentHyperParam, ExperimentHyperParamType, MetricName, MetricType,
  metricTypeParamMap, Primitive, Range,
} from 'types';
import { defaultNumericRange, getColorScale, getNumericRange, updateRange } from 'utils/chart';
import { clone } from 'utils/data';
import { numericSorter } from 'utils/sort';
import { metricNameToStr } from 'utils/string';
import { terminalRunStates } from 'utils/types';

import css from './HpParallelCoordinates.module.scss';
import HpTrialTable, { TrialHParams } from './HpTrialTable';

const { Option } = Select;

interface Props {
  batches: number[];
  experiment: ExperimentBase;
  hParams: string[];
  isLoading?: boolean;
  metrics: MetricName[];
  onBatchChange?: (batch: number) => void;
  onHParamChange?: (hParams?: string[]) => void;
  onMetricChange?: (metric: MetricName) => void;
  selectedBatch: number;
  selectedHParams: string[];
  selectedMetric: MetricName;
}

interface HpTrialData {
  data: Record<string, Primitive[]>;
  metricRange?: Range<number>;
  metricValues: number[];
  trialIds: number[];
}

const HpParallelCoordinates: React.FC<Props> = ({
  batches,
  experiment,
  hParams,
  isLoading = false,
  metrics,
  onBatchChange,
  onHParamChange,
  onMetricChange,
  selectedBatch,
  selectedHParams,
  selectedMetric,
}: Props) => {
  const tooltipRef = useRef<HTMLDivElement>(null);
  const trialIdRef = useRef<HTMLDivElement>(null);
  const metricValueRef = useRef<HTMLDivElement>(null);
  const [ hasLoaded, setHasLoaded ] = useState(false);
  const [ chartData, setChartData ] = useState<HpTrialData>();
  const [ trialHps, setTrialHps ] = useState<TrialHParams[]>([]);
  const [ pageError, setPageError ] = useState<Error>();
  const [ filteredTrialIdMap, setFilteredTrialIdMap ] = useState<Record<number, boolean>>();

  const hyperparameters = useMemo(() => {
    return hParams.reduce((acc, key) => {
      acc[key] = experiment.config.hyperparameters[key];
      return acc;
    }, {} as Record<string, ExperimentHyperParam>);
  }, [ experiment.config.hyperparameters, hParams ]);

  const isExperimentTerminal = terminalRunStates.has(experiment.state);

  const smallerIsBetter = useMemo(() => {
    if (selectedMetric.type === MetricType.Validation &&
        selectedMetric.name === experiment.config.searcher.metric) {
      return experiment.config.searcher.smallerIsBetter;
    }
    return undefined;
  }, [ experiment.config.searcher, selectedMetric ]);

  const colorScale = useMemo(() => {
    return getColorScale(chartData?.metricRange, smallerIsBetter);
  }, [ chartData?.metricRange, smallerIsBetter ]);

  const dimensions = useMemo(() => {
    const newDimensions = selectedHParams.map(key => {
      const hp = hyperparameters[key] || {};
      const dimension: Dimension = {
        label: key,
        type: dimensionTypeMap[hp.type],
      };

      if (hp.vals) dimension.categories = hp.vals;
      if (hp.minval != null && hp.maxval != null) {
        const isLogarithmic = hp.type === ExperimentHyperParamType.Log;
        dimension.range = isLogarithmic ?
          [ 10 ** hp.minval, 10 ** hp.maxval ] : [ hp.minval, hp.maxval ];
      }

      return dimension;
    });

    // Add metric as column to parcoords dimension list
    if (chartData?.metricRange) {
      newDimensions.push({
        label: metricNameToStr(selectedMetric),
        range: chartData.metricRange,
        type: DimensionType.Scalar,
      });
    }

    return newDimensions;
  }, [ chartData, hyperparameters, selectedMetric, selectedHParams ]);

  const resetData = useCallback(() => {
    setChartData(undefined);
    setTrialHps([]);
    setHasLoaded(false);
  }, []);

  const handleBatchChange = useCallback((batch: SelectValue) => {
    if (!onBatchChange) return;
    resetData();
    onBatchChange(batch as number);
  }, [ onBatchChange, resetData ]);

  const handleHParamChange = useCallback((hps: SelectValue) => {
    if (!onHParamChange) return;
    if (Array.isArray(hps)) {
      onHParamChange(hps.length === 0 ? undefined : hps as string[]);
    }
  }, [ onHParamChange ]);

  const handleMetricChange = useCallback((metric: MetricName) => {
    if (!onMetricChange) return;
    resetData();
    onMetricChange(metric);
  }, [ onMetricChange, resetData ]);

  const handleChartFilter = useCallback((constraints: Record<string, Constraint>) => {
    if (!chartData) return;

    // Figure out which trials fit within the user provided constraints.
    const newFilteredTrialIdMap = chartData.trialIds.reduce((acc, trialId) => {
      acc[trialId] = true;
      return acc;
    }, {} as Record<number, boolean>);

    Object.entries(constraints).forEach(([ key, constraint ]) => {
      if (!constraint) return;
      if (!chartData.data[key]) return;

      const range = constraint.range;
      const values = chartData.data[key];
      values.forEach((value, index) => {
        if (constraint.values && constraint.values.includes(value)) return;
        if (!constraint.values && value >= range[0] && value <= range[1]) return;
        const trialId = chartData.trialIds[index];
        newFilteredTrialIdMap[trialId] = false;
      });
    });

    setFilteredTrialIdMap(newFilteredTrialIdMap);
  }, [ chartData ]);

  useEffect(() => {
    const canceler = new AbortController();
    const trialMetricsMap: Record<number, number> = {};
    const trialHpTableMap: Record<number, TrialHParams> = {};
    const trialHpMap: Record<string, Record<number, Primitive>> = {};

    consumeStream<V1TrialsSnapshotResponse>(
      detApi.StreamingInternal.determinedTrialsSnapshot(
        experiment.id,
        selectedBatch,
        selectedMetric.name,
        metricTypeParamMap[selectedMetric.type],
        undefined,
        { signal: canceler.signal },
      ),
      event => {
        if (!event || !event.trials || !Array.isArray(event.trials)) return;

        const data: Record<string, Primitive[]> = {};
        let trialMetricRange: Range<number> = defaultNumericRange(true);

        event.trials.forEach(trial => {
          const id = trial.trialId;
          trialMetricsMap[id] = trial.metric;
          trialMetricRange = updateRange<number>(trialMetricRange, trial.metric);

          Object.keys(trial.hparams || {}).forEach(hpKey => {
            const hpValue = trial.hparams[hpKey];
            trialHpMap[hpKey] = trialHpMap[hpKey] || {};
            trialHpMap[hpKey][id] = hpValue;
          });

          trialHpTableMap[id] = {
            hparams: clone(trial.hparams),
            id,
            metric: trial.metric,
          };
        });

        const trialIds = Object.keys(trialMetricsMap)
          .map(id => parseInt(id))
          .sort(numericSorter);

        Object.keys(trialHpMap).forEach(hpKey => {
          data[hpKey] = trialIds.map(trialId => trialHpMap[hpKey][trialId]);
        });

        // Add metric of interest.
        const metricKey = metricNameToStr(selectedMetric);
        const metricValues = trialIds.map(id => trialMetricsMap[id]);
        data[metricKey] = metricValues;

        // Normalize metrics values for parallel coordinates colors.
        const metricRange = getNumericRange(metricValues);

        // Gather hparams for trial table.
        const newTrialHps = trialIds.map(id => trialHpTableMap[id]);
        setTrialHps(newTrialHps);

        setChartData({
          data,
          metricRange,
          metricValues,
          trialIds,
        });
        setHasLoaded(true);
      },
    ).catch(e => setPageError(e));

    return () => canceler.abort();
  }, [ experiment.id, selectedBatch, selectedMetric ]);

  if (pageError) {
    return <Message title={pageError.message} />;
  } else if (hasLoaded && !chartData) {
    return isExperimentTerminal ? (
      <Message title="No data to plot." type={MessageType.Empty} />
    ) : (
      <div className={css.waiting}>
        <Alert
          description="Please wait until the experiment is further along."
          message="Not enough data points to plot." />
        <Spinner />
      </div>
    );
  }

  return (
    <div className={css.base}>
      <Section
        options={<ResponsiveFilters>
          <SelectFilter
            enableSearchFilter={false}
            label="Batches Processed"
            showSearch={false}
            value={selectedBatch}
            onChange={handleBatchChange}>
            {batches.map(batch => <Option key={batch} value={batch}>{batch}</Option>)}
          </SelectFilter>
          <MetricSelectFilter
            defaultMetricNames={metrics}
            label="Metric"
            metricNames={metrics}
            multiple={false}
            value={selectedMetric}
            width={'100%'}
            onChange={handleMetricChange} />
          <MultiSelect
            label="HP"
            value={selectedHParams}
            onChange={handleHParamChange}>
            {hParams.map(hParam => <Option key={hParam} value={hParam}>{hParam}</Option>)}
          </MultiSelect>
        </ResponsiveFilters>}
        title="HP Parallel Coordinates">
        <div className={css.container}>
          {!hasLoaded || isLoading || !chartData ? <Spinner /> : (
            <>
              <div className={css.chart}>
                <ParallelCoordinates
                  colorScale={colorScale}
                  colorScaleKey={metricNameToStr(selectedMetric)}
                  data={chartData.data}
                  dimensions={dimensions}
                  onFilter={handleChartFilter}
                />
              </div>
              <div className={css.table}>
                <HpTrialTable
                  colorScale={colorScale}
                  experimentId={experiment.id}
                  filteredTrialIdMap={filteredTrialIdMap}
                  hyperparameters={hyperparameters}
                  metric={selectedMetric}
                  trialHps={trialHps}
                  trialIds={chartData.trialIds}
                />
              </div>
            </>
          )}
          <div className={css.tooltip} ref={tooltipRef}>
            <div className={css.box}>
              <div className={css.row}>
                <div>Trial Id:</div>
                <div ref={trialIdRef} />
              </div>
              <div className={css.row}>
                <div>Metric:</div>
                <div ref={metricValueRef} />
              </div>
            </div>
          </div>
        </div>
      </Section>
    </div>
  );
};

export default HpParallelCoordinates;
