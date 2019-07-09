import { subMonths } from 'date-fns'
import { connect } from 'react-redux'
import mapActivityValues from 'main/utils/mapActivityValues'
import routerParam from 'lib/utils/routerParam'
import { loadFeed } from 'main/actions/loadFeed'
import { loadFeedActivity } from 'main/actions/loadFeedActivity'

import {
  feedActivitySelector,
  feedPageStateSelector,
  feedSelector
} from 'main/selectors'

import { activityHistoryDepth } from 'index/constants'
import Main from './component'

function mapStateToProps (state) {
  const activityEndDate = new Date()
  const activityStartDate = subMonths(activityEndDate, activityHistoryDepth)

  return {
    activity: feedActivitySelector(state),
    activityEndDate,
    activityStartDate,
    mappedActivity: mapActivityValues(feedActivitySelector(state)),
    feed: feedSelector(state),
    pageState: feedPageStateSelector(state)
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  load: () => {
    const name = routerParam(ownProps, 'name')
    dispatch(loadFeed(name))
    dispatch(loadFeedActivity(name))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
