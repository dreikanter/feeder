import {
  LOAD_FEED_UPDATES_PENDING,
  LOAD_FEED_UPDATES_FULFILLED,
  LOAD_FEED_UPDATES_REJECTED
} from 'main/actions/loadFeedUpdates'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEED_UPDATES_PENDING:
    case LOAD_FEED_UPDATES_REJECTED: {
      return []
    }

    case LOAD_FEED_UPDATES_FULFILLED: {
      return action.payload.data.updates
    }

    default: {
      return state
    }
  }
}
