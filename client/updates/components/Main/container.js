import { connect } from 'react-redux'
import idRouterParam from 'lib/utils/idRouterParam'
import { loadBatches } from 'main/actions/loadBatches'
import { loadUpdates } from 'main/actions/loadUpdates'

import {
  batchesSelector,
  updatesSelector,
  pendingUpdatesPageSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  batches: batchesSelector(state),
  updates: updatesSelector(state),
  pending: pendingUpdatesPageSelector(state)
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  load: () => {
    const feedId = idRouterParam(ownProps)
    dispatch(loadUpdates(feedId))

    if (!feedId) {
      dispatch(loadBatches())
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
