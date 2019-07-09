import React from 'react'
import ErrorPage from 'lib/components/ErrorPage'

// NOTE: Prefer more concrete error feedback when possible

const LoadingError = () => (
  <ErrorPage title="Error">
    Error loading page
  </ErrorPage>
)

export default LoadingError
