import { connect } from 'react-redux'
import idRouterParam from 'lib/utils/idRouterParam'
import { loadUpdates } from 'main/actions/loadUpdates'

import {
  updatesSelector,
  pendingUpdatesPageSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  updates: updatesSelector(state),
  pending: pendingUpdatesPageSelector(state)
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  load: () => {
    const feedId = idRouterParam(ownProps)
    dispatch(loadUpdates(feedId))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
