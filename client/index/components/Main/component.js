import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
import Pending from 'lib/components/Pending'
import Stats from 'lib/components/Stats'
import getActivityTooltip from 'main/utils/getActivityTooltip'
import Feeds from 'index/components/Feeds'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const {
      activity,
      activityEndDate,
      activityStartDate,
      clickFeed,
      feeds,
      mappedActivity,
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
        <Heatmap
          getTooltipContent={date => getActivityTooltip(activity, date)}
          endDate={activityEndDate}
          startDate={activityStartDate}
          values={mappedActivity}
        />
        <Feeds click={clickFeed} records={feeds} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  activity: PropTypes.object,
  activityEndDate: PropTypes.object,
  activityStartDate: PropTypes.object,
  clickFeed: PropTypes.func,
  feeds: PropTypes.array,
  load: PropTypes.func,
  mappedActivity: PropTypes.array,
  pending: PropTypes.bool,
  stats: PropTypes.arrayOf(PropTypes.object)
}

Main.defaultProps = {
  activity: {},
  activityEndDate: undefined,
  activityStartDate: undefined,
  clickFeed: undefined,
  feeds: [],
  load: undefined,
  mappedActivity: [],
  pending: false,
  stats: []
}

export default Main
