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

import {
  LOAD_ACTIVITY,
  LOAD_ACTIVITY_PENDING,
  LOAD_ACTIVITY_FULFILLED,
  LOAD_ACTIVITY_REJECTED
} from 'main/actions/loadActivity'

import {
  LOAD_POSTS,
  LOAD_POSTS_PENDING,
  LOAD_POSTS_FULFILLED,
  LOAD_POSTS_REJECTED
} from 'main/actions/loadPosts'

import {
  LOAD_UPDATES,
  LOAD_UPDATES_PENDING,
  LOAD_UPDATES_FULFILLED,
  LOAD_UPDATES_REJECTED
} from 'main/actions/loadUpdates'

import {
  LOAD_FEED_ACTIVITY,
  LOAD_FEED_ACTIVITY_PENDING,
  LOAD_FEED_ACTIVITY_FULFILLED,
  LOAD_FEED_ACTIVITY_REJECTED
} from 'main/actions/loadFeedActivity'

import {
  LOAD_FEED_POSTS,
  LOAD_FEED_POSTS_PENDING,
  LOAD_FEED_POSTS_FULFILLED,
  LOAD_FEED_POSTS_REJECTED
} from 'main/actions/loadFeedPosts'

import {
  LOAD_FEED_UPDATES,
  LOAD_FEED_UPDATES_PENDING,
  LOAD_FEED_UPDATES_FULFILLED,
  LOAD_FEED_UPDATES_REJECTED
} from 'main/actions/loadFeedUpdates'

import {
  LOAD_BATCHES,
  LOAD_BATCHES_PENDING,
  LOAD_BATCHES_FULFILLED,
  LOAD_BATCHES_REJECTED
} from 'main/actions/loadBatches'

// TODO: Consider replacing this switch body with action mapping
// to make the reducer more compact

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

    case LOAD_ACTIVITY_PENDING: {
      return union(state, [LOAD_ACTIVITY])
    }

    case LOAD_ACTIVITY_FULFILLED:
    case LOAD_ACTIVITY_REJECTED: {
      return without(state, LOAD_ACTIVITY)
    }

    case LOAD_POSTS_PENDING: {
      return union(state, [LOAD_POSTS])
    }

    case LOAD_POSTS_FULFILLED:
    case LOAD_POSTS_REJECTED: {
      return without(state, LOAD_POSTS)
    }

    case LOAD_UPDATES_PENDING: {
      return union(state, [LOAD_UPDATES])
    }

    case LOAD_UPDATES_FULFILLED:
    case LOAD_UPDATES_REJECTED: {
      return without(state, LOAD_UPDATES)
    }

    case LOAD_BATCHES_PENDING: {
      return union(state, [LOAD_BATCHES])
    }

    case LOAD_BATCHES_FULFILLED:
    case LOAD_BATCHES_REJECTED: {
      return without(state, LOAD_BATCHES)
    }

    case LOAD_FEED_ACTIVITY_PENDING: {
      return union(state, [LOAD_FEED_ACTIVITY])
    }

    case LOAD_FEED_ACTIVITY_FULFILLED:
    case LOAD_FEED_ACTIVITY_REJECTED: {
      return without(state, LOAD_FEED_ACTIVITY)
    }

    case LOAD_FEED_POSTS_PENDING: {
      return union(state, [LOAD_FEED_POSTS])
    }

    case LOAD_FEED_POSTS_FULFILLED:
    case LOAD_FEED_POSTS_REJECTED: {
      return without(state, LOAD_FEED_POSTS)
    }

    case LOAD_FEED_UPDATES_PENDING: {
      return union(state, [LOAD_FEED_UPDATES])
    }

    case LOAD_FEED_UPDATES_FULFILLED:
    case LOAD_FEED_UPDATES_REJECTED: {
      return without(state, LOAD_FEED_UPDATES)
    }

    default: {
      return state
    }
  }
}
