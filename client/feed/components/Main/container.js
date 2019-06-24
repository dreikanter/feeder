import { connect } from 'react-redux'
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
  activity:
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
