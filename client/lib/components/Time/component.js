import moment from 'moment'
import React from 'react'
import PropTypes from 'prop-types'

function Time (props) {
  const {
    ago,
    renderContent,
    value,
    placeholder
  } = props

  if (!value) {
    return placeholder
  }

  const safeValue = moment(value)

  if (!safeValue.isValid()) {
    return (
      <span className="Time text-danger">{value}</span>
    )
  }

  if (renderContent) {
    return (
      <time className="Time" dateTime={value}>
        {renderContent(props)}
      </time>
    )
  }

  return (
    <time className="Time" dateTime={value}>
      {ago ? safeValue.fromNow() : safeValue.format('YYYY/MM/DD HH:mm')}
    </time>
  )
}

Time.propTypes = {
  ago: PropTypes.bool,
  renderContent: PropTypes.func,
  placeholder: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
  value: PropTypes.oneOfType([PropTypes.object, PropTypes.string])
}

Time.defaultProps = {
  ago: false,
  renderContent: undefined,
  placeholder: null,
  value: undefined
}

export default Time
