import { connect } from 'react-redux'
import { feedsSelector } from 'index/selectors'
import { pendingFeeds } from 'main/selectors'
import { loadFeeds } from 'main/actions/loadFeeds'
import Main from './component'

const mapStateToProps = state => ({
  feeds: feedsSelector(state),
  pending: pendingFeeds(state)
})

const mapDispatchToProps = dispatch => ({
  load: () => dispatch(loadFeeds())
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
