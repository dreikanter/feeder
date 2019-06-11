import {
  LOAD_POSTS_PENDING,
  LOAD_POSTS_FULFILLED,
  LOAD_POSTS_REJECTED
} from 'main/actions/loadPosts'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_POSTS_PENDING:
    case LOAD_POSTS_REJECTED: {
      return []
    }

    case LOAD_POSTS_FULFILLED: {
      return action.payload.data.posts
    }

    default: {
      return state
    }
  }
}
