import { createSelector } from 'reselect'
import { LOAD_FEED } from 'main/actions/loadFeed'
import { LOAD_FEEDS } from 'main/actions/loadFeeds'

export const indexSelector = root => root.index || []

export const feedSelector = root => root.feed || {}

export const pendingSelector = state => state.pending || []

export const statsSelector = state => state.stats || {}

export const pendingFeedsSelector = createSelector(
  pendingSelector,
  pending => pending.includes(LOAD_FEEDS)
)

export const pendingFeedSelector = createSelector(
  pendingSelector,
  pending => pending.includes(LOAD_FEED)
)

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
