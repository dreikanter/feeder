import { createSelector } from 'reselect'

const rootSelector = state => state.index

export const feedsSelector = createSelector(
  rootSelector,
  root => root.feeds || []
)

export const metaSelector = createSelector(
  rootSelector,
  root => root.meta || {}
)

export const statsSelector = createSelector(
  metaSelector,
  meta => ([
    {
      title: 'Feeds',
      value: meta.feeds_count
    },
    {
      title: 'Posts',
      value: meta.posts_count
    },
    {
      title: 'Subscriptions',
      value: meta.subscriptions_count
    },
    {
      title: 'Last update',
      value: meta.last_update
    },
    {
      title: 'Last post',
      value: meta.last_post
    },
  ])
)
