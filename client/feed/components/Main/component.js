import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
import Pending from 'lib/components/Pending'
import getActivityTooltip from 'main/utils/getActivityTooltip'
import Feed from 'feed/components/Feed'

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
      feed,
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
        <h1>
          Feed:
          {' '}
          <mark>{feed.name}</mark>
        </h1>
        <Heatmap
          getTooltipContent={date => getActivityTooltip(activity, date)}
          endDate={activityEndDate}
          startDate={activityStartDate}
          values={mappedActivity}
        />
        <Feed feed={feed} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  activity: PropTypes.object,
  activityEndDate: PropTypes.object,
  activityStartDate: PropTypes.object,
  feed: PropTypes.object,
  load: PropTypes.func,
  mappedActivity: PropTypes.array,
  pending: PropTypes.bool
}

Main.defaultProps = {
  activity: {},
  activityEndDate: undefined,
  activityStartDate: undefined,
  feed: {},
  load: undefined,
  mappedActivity: [],
  pending: false
}

export default Main
