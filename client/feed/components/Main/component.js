import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Heatmap from 'lib/components/Heatmap'
import LoadingError from 'lib/components/LoadingError'
import PageNotFound from 'lib/components/PageNotFound'
import pageStates from 'lib/constants/pageStates'
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
      pageState
    } = this.props

    switch (pageState) {
      case pageStates.pending: {
        return (
          <Pending />
        )
      }

      case pageStates.notFound: {
        return (
          <PageNotFound />
        )
      }

      case pageStates.error: {
        return (
          <LoadingError />
        )
      }

      default: {
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
  }
}

Main.propTypes = {
  activity: PropTypes.object,
  activityEndDate: PropTypes.object,
  activityStartDate: PropTypes.object,
  feed: PropTypes.object,
  load: PropTypes.func,
  mappedActivity: PropTypes.array,
  pageState: PropTypes.oneOf(Object.values(pageStates))
}

Main.defaultProps = {
  activity: {},
  activityEndDate: undefined,
  activityStartDate: undefined,
  feed: {},
  load: undefined,
  mappedActivity: [],
  pageState: undefined
}

export default Main
