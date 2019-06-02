import union from 'lodash/union'
import without from 'lodash/without'

import {
  LOAD_FEED,
  LOAD_FEED_PENDING,
  LOAD_FEED_FULFILLED,
  LOAD_FEED_REJECTED
} from 'main/actions/loadFeed'

import {
  LOAD_FEEDS,
  LOAD_FEEDS_PENDING,
  LOAD_FEEDS_FULFILLED,
  LOAD_FEEDS_REJECTED
} from 'main/actions/loadFeeds'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEEDS_PENDING: {
      return union(state, [LOAD_FEEDS])
    }

    case LOAD_FEEDS_FULFILLED:
    case LOAD_FEEDS_REJECTED: {
      return without(state, LOAD_FEEDS)
    }

    case LOAD_FEED_PENDING: {
      return union(state, [LOAD_FEED])
    }

    case LOAD_FEED_FULFILLED:
    case LOAD_FEED_REJECTED: {
      return without(state, LOAD_FEED)
    }

    default: {
      return state
    }
  }
}
