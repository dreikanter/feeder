import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
import Pending from 'lib/components/Pending'
import getActivityTooltip from 'main/utils/getActivityTooltip'
import Feeds from 'index/components/Feeds'
import OverallStats from 'index/components/OverallStats'

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
      pending
    } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <Fragment>
        <OverallStats />
        <Heatmap
          getTooltipContent={date => getActivityTooltip(activity, date)}
          endDate={activityEndDate}
          startDate={activityStartDate}
          values={mappedActivity}
        />
        <Feeds records={feeds} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  activity: PropTypes.object,
  activityEndDate: PropTypes.object,
  activityStartDate: PropTypes.object,
  feeds: PropTypes.array,
  load: PropTypes.func,
  mappedActivity: PropTypes.array,
  pending: PropTypes.bool
}

Main.defaultProps = {
  activity: {},
  activityEndDate: undefined,
  activityStartDate: undefined,
  feeds: [],
  load: undefined,
  mappedActivity: [],
  pending: false
}

export default Main
