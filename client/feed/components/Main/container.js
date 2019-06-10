import { connect } from 'react-redux'
import idRouterParam from 'lib/utils/idRouterParam'
import { loadFeed } from 'main/actions/loadFeed'

import {
  feedSelector,
  pendingFeedSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  feed: feedSelector(state),
  pending: pendingFeedSelector(state)
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  load: () => {
    const feedId = idRouterParam(ownProps)
    dispatch(loadFeed(feedId))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
