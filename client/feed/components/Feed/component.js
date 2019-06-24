import React from 'react'
import PropTypes from 'prop-types'
import every from 'lib/utils/every'
import formatTime from 'lib/utils/formatTime'
import HorizontalTable from 'lib/components/HorizontalTable'
import MutedZero from 'lib/components/MutedZero'

/* eslint-disable react/prop-types, camelcase */
const feedPresenters = ([
  {
    label: 'Name',
    value: ({ name }) => `@${name}`
  },
  {
    label: 'Freefeed group',
    value: ({ name }) => {
      const url = `https://freefeed.net/${name}`

      return (
        <a href={url}>{url}</a>
      )
    }
  },
  {
    label: 'Posts count',
    value: ({ posts_count }) => (
      <MutedZero value={posts_count || 0} />
    )
  },
  {
    label: 'Refreshed at',
    value: ({ refreshed_at }) => formatTime(refreshed_at)
  },
  {
    label: 'Last post created at',
    value: ({ last_post_created_at }) => formatTime(last_post_created_at)
  },
  {
    label: 'Updated at',
    value: ({ updated_at }) => formatTime(updated_at)
  },
  {
    label: 'Created at',
    value: ({ created_at }) => formatTime(created_at)
  },
  {
    label: 'Source URL',
    value: ({ url }) => (
      <a href={url}>{url}</a>
    )
  },
  {
    label: 'Loader',
    value: ({ loader }) => loader || 'default'
  },
  {
    label: 'Processor',
    value: ({ processor }) => processor
  },
  {
    label: 'Normalizer',
    value: ({ normalizer }) => normalizer
  },
  {
    label: 'Import posts created after',
    value: ({ after }) => formatTime(after)
  },
  {
    label: 'Refresh interval',
    value: ({ refresh_interval }) => every(refresh_interval)
  },
  {
    label: 'Import limit',
    value: ({ import_limit }) => (
      <MutedZero value={import_limit || 0} />
    )
  }
])
/* eslint-enable react/prop-types, camelcase */

const Feed = ({ feed }) => (
  <HorizontalTable
    object={feed}
    presenters={feedPresenters}
  />
)

Feed.propTypes = {
  feed: PropTypes.object.isRequired
}

export default Feed
