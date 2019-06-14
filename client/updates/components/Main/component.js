import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Pending from 'lib/components/Pending'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { updates, pending } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <pre>
        {JSON.stringify(updates, null, 2)}
      </pre>
    )
  }
}

Main.propTypes = {
  updates: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  updates: [],
  load: undefined,
  pending: false
}

export default Main
