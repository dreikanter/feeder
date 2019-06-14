import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'lib/components/Placeholder'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { posts, pending } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <pre>
        {JSON.stringify(posts, null, 2)}
      </pre>
    )
  }
}

Main.propTypes = {
  posts: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  posts: [],
  load: undefined,
  pending: false
}

export default Main
