import pluralize from 'pluralize'
import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
import Pending from 'lib/components/Pending'
import Stats from 'lib/components/Stats'
import Feeds from 'index/components/Feeds'

function getTooltipContent (activity, date) {
  const count = activity[date]

  if (!count) {
    return null
  }

  return (
    <Fragment>
      {date}
      {' → '}
      <b>{pluralize('post', count, true)}</b>
    </Fragment>
  )
}

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
          getTooltipContent={date => getTooltipContent(activity, date)}
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
