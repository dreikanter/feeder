import React, { Fragment } from 'react'
import PropTypes from 'prop-types'
import Mute from 'lib/components/Mute'

function ConditionalPlaceholder ({ children, condition, placeholder }) {
  if (condition) {
    return (
      <Fragment>{children}</Fragment>
    )
  }

  return (
    <Mute>{placeholder}</Mute>
  )
}

ConditionalPlaceholder.propTypes = {
  children: PropTypes.any,
  condition: PropTypes.bool,
  placeholder: PropTypes.string
}

ConditionalPlaceholder.defaultProps = {
  children: undefined,
  condition: undefined,
  placeholder: 'Undefined'
}

export default ConditionalPlaceholder
