import React from 'react'
import PropTypes from 'prop-types'
import CalendarHeatmap from 'react-calendar-heatmap'
import ReactTooltip from 'react-tooltip'
import 'react-calendar-heatmap/dist/styles.css'
import './style.scss'

const Heatmap = ({ values }) => (
  <div className="Heatmap">
    <CalendarHeatmap
      values={values}
      tooltipDataAttrs={({ tip }) => tip}
    />
    <ReactTooltip />
  </div>
)

Heatmap.propTypes = {
  values: PropTypes.arrayOf(PropTypes.number)
}

Heatmap.defaultProps = {
  values: []
}

export default Heatmap
