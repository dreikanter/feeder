import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
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
      activity,
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
        <Heatmap values={activity} />
        <Feeds click={clickFeed} records={feeds} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  activity: PropTypes.object,
  clickFeed: PropTypes.func,
  feeds: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool,
  stats: PropTypes.arrayOf(PropTypes.object)
}

Main.defaultProps = {
  activity: {},
  clickFeed: undefined,
  feeds: [],
  load: undefined,
  pending: false,
  stats: []
}

export default Main
