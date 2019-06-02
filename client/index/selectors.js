import { createSelector } from 'reselect'
import { LOAD_FEEDS } from 'main/actions/loadFeeds'

const rootSelector = state => state.index

export const feedsSelector = createSelector(
  rootSelector,
  root => root.feeds || []
)

export const pendingSelector = createSelector(
  rootSelector,
  root => root.pending || []
)

export const pendingFeeds = createSelector(
  pendingSelector,
  pending => pending.includes(LOAD_FEEDS)
)
