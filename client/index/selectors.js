import { createSelector } from 'reselect'

const rootSelector = state => state.index

export const feedsSelector = createSelector(
  rootSelector,
  root => root.feeds || []
)
