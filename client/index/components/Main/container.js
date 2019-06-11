import { connect } from 'react-redux'
import { push } from 'connected-react-router'
import { loadFeeds } from 'main/actions/loadFeeds'
import paths from 'main/paths'

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
  clickFeed: ({ name }) => dispatch(push(paths.feedPath(name))),
  load: () => dispatch(loadFeeds())
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
