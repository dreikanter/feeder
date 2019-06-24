import moment from 'moment'
import React from 'react'
import PropTypes from 'prop-types'

function Time (props) {
  const {
    ago,
    renderContent,
    format,
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

  const formatted = ago ? safeValue.fromNow() : safeValue.format(format)

  return (
    <time className="Time" dateTime={value}>
      {formatted}
    </time>
  )
}

Time.propTypes = {
  ago: PropTypes.bool,
  renderContent: PropTypes.func,
  format: PropTypes.string,
  placeholder: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
  value: PropTypes.oneOfType([PropTypes.object, PropTypes.string])
}

Time.defaultProps = {
  ago: false,
  renderContent: undefined,
  format: 'lll',
  placeholder: null,
  value: undefined
}

export default Time
