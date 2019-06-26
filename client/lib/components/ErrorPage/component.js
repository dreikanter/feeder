import React from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'lib/components/Placeholder'

const ErrorPage = ({ children, title }) => (
  <Placeholder>
    {title && (
      <h2>{title}</h2>
    )}
    {children && (
      <p>{children}</p>
    )}
  </Placeholder>
)

ErrorPage.propTypes = {
  title: PropTypes.string,
  children: PropTypes.oneOfType([PropTypes.string, PropTypes.node])
}

ErrorPage.defaultProps = {
  title: undefined,
  children: undefined
}

export default ErrorPage
