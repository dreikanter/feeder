import { connect } from 'react-redux'
import { loadPosts } from 'main/actions/loadPosts'

import {
  pendingPostsSelector,
  postFeedsSelector,
  postsFeedNameSelector,
  postsSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  feedName: postsFeedNameSelector(state),
  feeds: postFeedsSelector(state),
  pending: pendingPostsSelector(state),
  posts: postsSelector(state)
})

const mapDispatchToProps = dispatch => ({
  load: () => dispatch(loadPosts())
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
