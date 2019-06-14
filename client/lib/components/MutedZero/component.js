import React, { Fragment } from 'react'
import PropTypes from 'prop-types'

function MutedZero ({ value }) {
  if (value === 0) {
    return (
      <span className="text-muted">{value}</span>
    )
  }

  return (
    <Fragment>{value}</Fragment>
  )
}

MutedZero.propTypes = {
  value: PropTypes.number.isRequired
}

export default MutedZero
