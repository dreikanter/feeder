import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Pending from 'lib/components/Pending'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { feed, pending } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <pre>
        {JSON.stringify(feed, null, 2)}
      </pre>
    )
  }
}

Main.propTypes = {
  feed: PropTypes.object,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  feed: {},
  load: undefined,
  pending: false
}

export default Main
