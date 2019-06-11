import {
  LOAD_FEED_PENDING,
  LOAD_FEED_FULFILLED,
  LOAD_FEED_REJECTED
} from 'main/actions/loadFeed'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEED_PENDING:
    case LOAD_FEED_REJECTED: {
      return {}
    }

    case LOAD_FEED_FULFILLED: {
      return action.payload.data.feed
    }

    default: {
      return state
    }
  }
}
