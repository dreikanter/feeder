import { createSelector } from 'reselect'
import { LOAD_FEED } from 'main/actions/loadFeed'
import { LOAD_FEEDS } from 'main/actions/loadFeeds'
import { LOAD_POSTS } from 'main/actions/loadPosts'
import { LOAD_UPDATES } from 'main/actions/loadUpdates'
import { LOAD_ACTIVITY } from 'main/actions/loadActivity'
import { LOAD_BATCHES } from 'main/actions/loadBatches'
import { LOAD_FEED_POSTS } from 'main/actions/loadFeedPosts'
import { LOAD_FEED_UPDATES } from 'main/actions/loadFeedUpdates'
import { LOAD_FEED_ACTIVITY } from 'main/actions/loadFeedActivity'

export const indexSelector = root => root.index || []

export const feedSelector = root => root.feed || {}

export const pendingSelector = state => state.pending || []

export const statsSelector = state => state.stats || {}

export const postsSelector = state => state.posts || []

export const updatesSelector = state => state.updates || []

export const activitySelector = state => state.activity || []

export const batchesSelector = state => state.batches || []

export const feedPostsSelector = state => state.feedPosts || []

export const feedUpdatesSelector = state => state.feedUpdates || []

export const feedActivitySelector = state => state.feedActivity || []

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

export const statValuesSelector = createSelector(
  statsSelector,
  stats => ([
    {
      title: 'Feeds',
      value: stats.feeds_count
    },
    {
      title: 'Posts',
      value: stats.posts_count
    },
    {
      title: 'Subscriptions',
      value: stats.subscriptions_count
    },
    {
      title: 'Last update',
      value: stats.last_update
    },
    {
      title: 'Last post',
      value: stats.last_post
    },
  ])
)
