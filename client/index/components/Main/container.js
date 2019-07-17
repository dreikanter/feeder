import { subMonths } from 'date-fns'
import { connect } from 'react-redux'
import { loadActivity } from 'main/actions/loadActivity'
import { loadFeeds } from 'main/actions/loadFeeds'
import mapActivityValues from 'main/utils/mapActivityValues'

import {
  activitySelector,
  indexSelector,
  pendingFeedsPageSelector
} from 'main/selectors'

import { activityHistoryDepth } from 'index/constants'
import Main from './component'

function mapStateToProps (state) {
  const activityEndDate = new Date()
  const activityStartDate = subMonths(activityEndDate, activityHistoryDepth)

  return {
    activity: activitySelector(state),
    activityEndDate,
    activityStartDate,
    feeds: indexSelector(state),
    mappedActivity: mapActivityValues(activitySelector(state)),
    pending: pendingFeedsPageSelector(state)
  }
}

const mapDispatchToProps = dispatch => ({
  load: () => {
    dispatch(loadFeeds())
    dispatch(loadActivity())
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
