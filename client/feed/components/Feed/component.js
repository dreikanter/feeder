import React from 'react'
import PropTypes from 'prop-types'
import every from 'lib/utils/every'
import formatTime from 'lib/utils/formatTime'
import HorizontalTable from 'lib/components/HorizontalTable'
import Mute from 'lib/components/Mute'
import MutedZero from 'lib/components/MutedZero'

const noConstrants = <Mute>No constraints</Mute>

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
      <MutedZero>{posts_count}</MutedZero>
    )
  },
  {
    label: 'Refreshed at',
    value: ({ refreshed_at }) => formatTime(refreshed_at)
  },
  {
    label: 'Last post created at',
    value: ({ last_post_created_at }) => formatTime(last_post_created_at, 'None')
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
    value: ({ loader }) => <code>{loader || 'default'}</code>
  },
  {
    label: 'Processor',
    value: ({ processor }) => <code>{processor}</code>
  },
  {
    label: 'Normalizer',
    value: ({ normalizer }) => <code>{normalizer}</code>
  },
  {
    label: 'Import posts created after',
    value: ({ after }) => formatTime(after)
  },
  {
    label: 'Refresh interval',
    value: ({ refresh_interval }) => {
      if (refresh_interval === 0) {
        return noConstrants
      }

      return every(refresh_interval)
    }
  },
  {
    label: 'Import limit',
    value: ({ import_limit }) => import_limit || noConstrants
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
