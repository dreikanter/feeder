import { connect } from 'react-redux'
import { loadFeeds } from 'main/actions/loadFeeds'

import {
  indexSelector,
  pendingFeedsSelector,
  statValuesSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  feeds: indexSelector(state),
  pending: pendingFeedsSelector(state),
  stats: statValuesSelector(state)
})

const mapDispatchToProps = dispatch => ({
  load: () => dispatch(loadFeeds())
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
