import {
  LOAD_FEED_ACTIVITY_PENDING,
  LOAD_FEED_ACTIVITY_FULFILLED,
  LOAD_FEED_ACTIVITY_REJECTED
} from 'main/actions/loadFeedActivity'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEED_ACTIVITY_PENDING:
    case LOAD_FEED_ACTIVITY_REJECTED: {
      return []
    }

    case LOAD_FEED_ACTIVITY_FULFILLED: {
      return action.payload.data
    }

    default: {
      return state
    }
  }
}
