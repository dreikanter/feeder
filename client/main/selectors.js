import get from 'lodash/get'
import { createSelector } from 'reselect'

import {
  pending,
  notFound,
  error,
  ready
} from 'lib/constants/pageStates'

import { LOAD_FEED } from 'main/actions/loadFeed'
import { LOAD_FEEDS } from 'main/actions/loadFeeds'
import { LOAD_POSTS } from 'main/actions/loadPosts'
import { LOAD_UPDATES } from 'main/actions/loadUpdates'
import { LOAD_ACTIVITY } from 'main/actions/loadActivity'
import { LOAD_BATCHES } from 'main/actions/loadBatches'
import { LOAD_FEED_POSTS } from 'main/actions/loadFeedPosts'
import { LOAD_FEED_UPDATES } from 'main/actions/loadFeedUpdates'
import { LOAD_FEED_ACTIVITY } from 'main/actions/loadFeedActivity'

//
// Root selectors
//

export const indexSelector = state => state.index || []

export const feedSelector = state => state.feed || {}

export const pendingSelector = state => state.pending || []

export const statsSelector = state => state.stats || {}

export const postsRootSelector = state => state.posts || []

export const updatesSelector = state => state.updates || []

export const activitySelector = state => state.activity || {}

export const batchesSelector = state => state.batches || []

export const feedPostsSelector = state => state.feedPosts || []

export const feedUpdatesSelector = state => state.feedUpdates || []

export const feedActivitySelector = state => state.feedActivity || {}

export const errorsSelector = state => state.errors || {}

//
// Pending state
//

const createPendingSelector = actionType => createSelector(
  pendingSelector,
  pending => pending.includes(actionType)
)

export const pendingFeedsSelector =
  createPendingSelector(LOAD_FEEDS)

export const pendingFeedSelector =
  createPendingSelector(LOAD_FEED)

export const pendingPostsSelector =
  createPendingSelector(LOAD_POSTS)

export const pendingUpdatesSelector =
  createPendingSelector(LOAD_UPDATES)

export const pendingActivitySelector =
  createPendingSelector(LOAD_ACTIVITY)

export const pendingBatchesSelector =
  createPendingSelector(LOAD_BATCHES)

export const pendingFeedPostsSelector =
  createPendingSelector(LOAD_FEED_POSTS)

export const pendingFeedUpdatesSelector =
  createPendingSelector(LOAD_FEED_UPDATES)

export const pendingFeedActivitySelector =
  createPendingSelector(LOAD_FEED_ACTIVITY)

export const pendingUpdatesPageSelector = createSelector(
  pendingBatchesSelector,
  pendingUpdatesSelector,
  (pendingBatches, pendingUpdates) => pendingBatches || pendingUpdates
)

export const pendingFeedsPageSelector = createSelector(
  pendingFeedsSelector,
  pendingActivitySelector,
  (pendingFeeds, pendingActivity) => pendingFeeds || pendingActivity
)

export const pendingFeedPageSelector = createSelector(
  pendingFeedSelector,
  pendingActivitySelector,
  (pendingFeeds, pendingActivity) => pendingFeeds || pendingActivity
)

//
// Errors
//

const errorFeedActivitySelector = createSelector(
  errorsSelector,
  errors => errors[LOAD_FEED_ACTIVITY]
)

const errorFeedSelector = createSelector(
  errorsSelector,
  errors => errors[LOAD_FEED]
)

//
// Pages state
//

const statusNotFound = 404

export const feedPageStateSelector = createSelector(
  pendingFeedActivitySelector,
  pendingFeedSelector,
  errorFeedActivitySelector,
  errorFeedSelector,
  (pendingFeedActivity, pendingFeed, errorFeedActivity, errorFeed) => {
    if (pendingFeedActivity || pendingFeed) {
      return pending
    }

    if (errorFeedActivity || errorFeed) {
      if (get(errorFeed, ['response', 'status']) === statusNotFound) {
        return notFound
      }

      return error
    }

    return ready
  }
)

export const postsSelector = createSelector(
  postsRootSelector,
  postsRoot => postsRoot.posts
)

export const postFeedsSelector = createSelector(
  postsRootSelector,
  postsRoot => postsRoot.feeds
)

export const postsFeedNameSelector = createSelector(
  postsRootSelector,
  postsRoot => postsRoot.feed_name
)
