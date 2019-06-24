import React from 'react'
import PropTypes from 'prop-types'

const Mute = ({ children }) => <span className="text-muted">{children}</span>

Mute.propTypes = {
  children: PropTypes.any.isRequired
}

export default Mute
