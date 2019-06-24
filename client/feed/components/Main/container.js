import moment from 'moment'
import { connect } from 'react-redux'
import mapActivityValues from 'main/utils/mapActivityValues'
import routerParam from 'lib/utils/routerParam'
import { loadFeed } from 'main/actions/loadFeed'
import { loadFeedActivity } from 'main/actions/loadFeedActivity'

import {
  feedActivitySelector,
  feedSelector,
  pendingFeedPageSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  activity: feedActivitySelector(state),
  activityEndDate: moment().toDate(),
  activityStartDate: moment().subtract(12, 'months').toDate(),
  mappedActivity: mapActivityValues(feedActivitySelector(state)),
  feed: feedSelector(state),
  pending: pendingFeedPageSelector(state)
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  load: () => {
    const name = routerParam(ownProps, 'name')
    dispatch(loadFeed(name))
    dispatch(loadFeedActivity(name))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
