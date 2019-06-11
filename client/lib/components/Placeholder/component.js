import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import './style'

const Placeholder = ({ children, className, label }) => (
  <div className={cc('Placeholder', className)}>
    {label || children}
  </div>
)

Placeholder.propTypes = {
  children: PropTypes.any,
  className: PropTypes.string,
  label: PropTypes.string
}

Placeholder.defaultProps = {
  children: undefined,
  className: undefined,
  label: undefined
}

export default Placeholder
