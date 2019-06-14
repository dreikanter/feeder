import moment from 'moment'
import React from 'react'
import PropTypes from 'prop-types'

function fullFormat (value) {
  return value.format('YYYY/MM/DD HH:mm')
}

function format (value) {
  if (value.isAfter(moment().subtract(48, 'hours'))) {
    return value.fromNow()
  }

  if (value.isAfter(moment().startOf('year'))) {
    return value.format('MM/DD HH:mm')
  }

  return fullFormat(value)
}

function ReadableTime ({ value }) {
  const parsedValue = moment(value)

  if (!parsedValue.isValid()) {
    return null
  }

  return (
    <time dateTime={value} title={fullFormat(parsedValue)}>
      {format(parsedValue)}
    </time>
  )
}

ReadableTime.propTypes = {
  value: PropTypes.string
}

ReadableTime.defaultProps = {
  value: undefined
}

export default ReadableTime
