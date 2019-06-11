import { connect } from 'react-redux'
import routerParam from 'lib/utils/routerParam'
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
    const name = routerParam(ownProps, 'name')
    dispatch(loadFeed(name))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
