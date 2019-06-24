import moment from 'moment'
import { connect } from 'react-redux'
import { push } from 'connected-react-router'
import { loadActivity } from 'main/actions/loadActivity'
import { loadFeeds } from 'main/actions/loadFeeds'
import paths from 'main/paths'

import {
  activitySelector,
  indexSelector,
  pendingFeedsPageSelector,
  statValuesSelector
} from 'main/selectors'

import Main from './component'

const mapActivityValues = values => (
  Object.keys(values).map(date => ({ count: values[date], date }))
)

const mapStateToProps = state => ({
  activity: mapActivityValues(activitySelector(state)),
  activityStartDate: moment().subtract(12, 'months').toDate(),
  activityEndDate: moment().toDate(),
  feeds: indexSelector(state),
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
