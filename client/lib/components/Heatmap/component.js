import React from 'react'
import PropTypes from 'prop-types'
import CalendarHeatmap from 'react-calendar-heatmap'
import ReactTooltip from 'react-tooltip'
import scale from 'lib/utils/scale'
import 'react-calendar-heatmap/dist/styles.css'
import './style.scss'

// Should match the stylesheet
const minColor = 1
const maxColor = 4

function classForValue (value, min, max) {
  if (!value) {
    return 'Heatmap__empty';
  }

  const { count } = value
  const color = Math.round(scale(count, min, max, minColor, maxColor))

  return `Heatmap__color-${color}`
}

function tooltipDataAttrs ({ count, date }) {
  if (!count || !date) {
    return {}
  }

  return {
    'data-tip': `${date}: ${count}`
  }
}

function findMinMax (values) {
  let min = values[0].count
  let max = values[0].count

  for (let i = 1, length = values.length; i < length; i++) {
    let { count } = values[i]
    min = (count < min) ? count : min
    max = (count > max) ? count : max
  }

  return [min, max]
}

function Heatmap ({
  endDate,
  startDate,
  values
}) {
  if (!values.length) {
    return null
  }

  const [minCount, maxCount] = findMinMax(values.filter(value => !!value))

  return (
    <div className="Heatmap">
      <CalendarHeatmap
        classForValue={value => classForValue(value, minCount, maxCount)}
        endDate={endDate}
        startDate={startDate}
        tooltipDataAttrs={tooltipDataAttrs}
        values={values}
      />
      <ReactTooltip place="top" type="dark" effect="float" />
    </div>
  )
}

Heatmap.propTypes = {
  endDate: PropTypes.object,
  startDate: PropTypes.object,
  values: PropTypes.arrayOf(PropTypes.object)
}

Heatmap.defaultProps = {
  endDate: undefined,
  startDate: undefined,
  values: []
}

export default Heatmap
