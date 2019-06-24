import moment from 'moment'
import { connect } from 'react-redux'
import { push } from 'connected-react-router'
import { loadActivity } from 'main/actions/loadActivity'
import { loadFeeds } from 'main/actions/loadFeeds'
import paths from 'main/paths'
import mapActivityValues from 'main/utils/mapActivityValues'

import {
  activitySelector,
  indexSelector,
  pendingFeedsPageSelector,
  statValuesSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  activity: activitySelector(state),
  activityEndDate: moment().toDate(),
  activityStartDate: moment().subtract(12, 'months').toDate(),
  feeds: indexSelector(state),
  mappedActivity: mapActivityValues(activitySelector(state)),
  pending: pendingFeedsPageSelector(state),
  stats: statValuesSelector(state)
})

const mapDispatchToProps = dispatch => ({
  clickFeed: ({ name }) => dispatch(push(paths.feedPath(name))),
  load: () => {
    dispatch(loadFeeds())
    dispatch(loadActivity())
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
