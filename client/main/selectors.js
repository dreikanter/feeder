import { createSelector } from 'reselect'
import { LOAD_FEED } from 'main/actions/loadFeed'
import { LOAD_FEEDS } from 'main/actions/loadFeeds'

export const pendingSelector = state => state.pending || []

export const pendingFeeds = createSelector(
  pendingSelector,
  pending => pending.includes(LOAD_FEEDS)
)

export const pendingFeed = createSelector(
  pendingSelector,
  pending => pending.includes(LOAD_FEED)
)
