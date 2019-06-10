import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import './style'

const Placeholder = ({ className, label }) => (
  <div className={cc('Placeholder', className)}>
    {label}
  </div>
)

Placeholder.propTypes = {
  className: PropTypes.string,
  label: PropTypes.string.isRequired
}

Placeholder.defaultProps = {
  className: undefined
}

export default Placeholder
