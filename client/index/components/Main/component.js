import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Pending from 'lib/components/Pending'
import Stats from 'lib/components/Stats'
import Feeds from 'index/components/Feeds'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const {
      clickFeed,
      feeds,
      pending,
      stats
    } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <Fragment>
        <Stats items={stats} />
        <Feeds click={clickFeed} records={feeds} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  clickFeed: PropTypes.func,
  feeds: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool,
  stats: PropTypes.arrayOf(PropTypes.object)
}

Main.defaultProps = {
  clickFeed: undefined,
  feeds: [],
  load: undefined,
  pending: false,
  stats: []
}

export default Main
