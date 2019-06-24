import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Pending from 'lib/components/Pending'
import Feed from 'feed/components/Feed'

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
      <Fragment>
        <h1>
          Feed:
          {' '}
          <mark>{feed.name}</mark>
        </h1>
        <Feed feed={feed} />
      </Fragment>
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
