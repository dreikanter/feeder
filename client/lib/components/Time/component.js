import {
  distanceInWordsToNow,
  format,
  isValid,
  parse
} from 'date-fns'

import React from 'react'
import PropTypes from 'prop-types'

const fullDateFormat = 'YYYY/MM/DD HH:mm'

function conditionalFormat (value, ago) {
  if (ago) {
    return distanceInWordsToNow(value, { addSuffix: true })
  }

  return format(value, fullDateFormat)
}

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

  const parsedValue = parse(value)

  if (!isValid(parsedValue)) {
    return (
      <span className="Time text-danger">
        {value}
      </span>
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
      {conditionalFormat(parsedValue, ago)}
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
