import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import CalendarHeatmap from 'react-calendar-heatmap'
import ReactTooltip from 'react-tooltip'
import 'react-calendar-heatmap/dist/styles.css'

function tooltipDataAttrs ({ count, date }) {
  const formattedDate = [
    date.getDate(),
    date.getMonth() + 1,
    date.getFullYear()
  ].join('/')

  return {
    'data-tip': `${formattedDate}: ${count}`
  }
}

const mapValues = values => (
  Object.keys(values).map(date => ({ date, count: values[date] }))
)

const Heatmap = ({ values }) => (
  <Fragment>
    <CalendarHeatmap
      values={mapValues(values)}
      tooltipDataAttrs={tooltipDataAttrs}
    />
    <ReactTooltip />
  </Fragment>
)

Heatmap.propTypes = {
  values: PropTypes.arrayOf(PropTypes.number)
}

Heatmap.defaultProps = {
  values: []
}

export default Heatmap
