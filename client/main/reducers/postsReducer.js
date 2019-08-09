import reduce from 'lodash/reduce'

import {
  LOAD_POSTS_PENDING,
  LOAD_POSTS_FULFILLED,
  LOAD_POSTS_REJECTED
} from 'main/actions/loadPosts'

const reduceFeed = (result, value) => (
  Object.assign(result, { [value.id]: value })
)

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_POSTS_PENDING:
    case LOAD_POSTS_REJECTED: {
      return []
    }

    case LOAD_POSTS_FULFILLED: {
      const { meta, posts } = action.payload.data
      const { feeds, feed_name } = meta
      return {
        feed_name,
        feeds: reduce(feeds, reduceFeed, {}),
        posts
      }
    }

    default: {
      return state
    }
  }
}
