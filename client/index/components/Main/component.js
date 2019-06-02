import React, { useEffect } from 'react'
import PropTypes from 'prop-types'

function Main ({ load, pending }) {
  useEffect(() => {
    load()
  })

  if (pending) {
    return (
      <div>
        Loading...
      </div>
    )
  }

  return (
    <div>
      Index
    </div>
  )
}

Main.propTypes = {
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  load: undefined,
  pending: undefined
}

export default Main
