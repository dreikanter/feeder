import {
  LOAD_FEED_POSTS_PENDING,
  LOAD_FEED_POSTS_FULFILLED,
  LOAD_FEED_POSTS_REJECTED
} from 'main/actions/loadFeedPosts'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEED_POSTS_PENDING:
    case LOAD_FEED_POSTS_REJECTED: {
      return []
    }

    case LOAD_FEED_POSTS_FULFILLED: {
      return action.payload.data
    }

    default: {
      return state
    }
  }
}
