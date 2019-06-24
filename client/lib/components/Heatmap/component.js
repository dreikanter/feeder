import React from 'react'
import PropTypes from 'prop-types'
import CalendarHeatmap from 'react-calendar-heatmap'
import ReactTooltip from 'react-tooltip'
import 'react-calendar-heatmap/dist/styles.css'
import './style.scss'

function tooltipDataAttrs ({ count, date }) {
  if (!count || !date) {
    return {}
  }

  return {
    'data-tip': `${date}: ${count}`
  }
}

const Heatmap = ({
  endDate,
  startDate,
  values
}) => (
  <div className="Heatmap">
    <CalendarHeatmap
      endDate={endDate}
      startDate={startDate}
      tooltipDataAttrs={tooltipDataAttrs}
      values={values}
    />
    <ReactTooltip place="top" type="dark" effect="float" />
  </div>
)

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
