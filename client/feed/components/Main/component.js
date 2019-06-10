import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'lib/components/Placeholder'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { feed, pending } = this.props

    if (pending) {
      return (
        <Placeholder label="Loading..." />
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
  feed: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  feed: [],
  load: undefined,
  pending: false
}

export default Main
