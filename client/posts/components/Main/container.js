import { connect } from 'react-redux'
import { loadPosts } from 'main/actions/loadPosts'

import {
  postsSelector,
  pendingPostsSelector
} from 'main/selectors'

import Main from './component'

const mapStateToProps = state => ({
  posts: postsSelector(state),
  pending: pendingPostsSelector(state)
})

const mapDispatchToProps = dispatch => ({
  click: ({ post_url }) => {
    window.open(post_url)
  },
  load: () => dispatch(loadPosts())
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
