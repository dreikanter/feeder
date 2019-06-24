import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import Mute from 'lib/components/Mute'

function MutedZero ({ children }) {
  if (!children) {
    return (
      <Mute>{children}</Mute>
    )
  }

  return (
    <Fragment>{children}</Fragment>
  )
}

MutedZero.propTypes = {
  children: PropTypes.number
}

MutedZero.defaultProps = {
  children: undefined
}

export default MutedZero
