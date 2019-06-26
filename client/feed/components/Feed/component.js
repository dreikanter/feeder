import React from 'react'
import PropTypes from 'prop-types'
import every from 'lib/utils/every'
import HorizontalTable from 'lib/components/HorizontalTable'
import Mute from 'lib/components/Mute'
import Time from 'lib/components/Time'

const noConstrants = <Mute>No constraints</Mute>

const timestampPlaceholder = <Mute>–</Mute>

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
    value: ({ posts_count }) => posts_count
  },
  {
    label: 'Avg. posts per week',
    value: ({ avg_posts_per_week }) => (avg_posts_per_week || 0).toFixed(1)
  },
  {
    label: 'Subscribers',
    value: ({ subscriptions_count }) => subscriptions_count
  },
  {
    label: 'Refreshed at',
    value: ({ refreshed_at }) => (
      <Time value={refreshed_at} placeholder={timestampPlaceholder} />
    )
  },
  {
    label: 'Last post created at',
    value: ({ last_post_created_at }) => (
      <Time value={last_post_created_at} placeholder={timestampPlaceholder} />
    )
  },
  {
    label: 'Updated at',
    value: ({ updated_at }) => (
      <Time value={updated_at} placeholder={timestampPlaceholder} />
    )
  },
  {
    label: 'Created at',
    value: ({ created_at }) => (
      <Time value={created_at} placeholder={timestampPlaceholder} />
    )
  },
  {
    label: 'Source URL',
    value: ({ url }) => (
      url ? <a href={url}>{url}</a> : <Mute>Not specified</Mute>
    )
  },
  {
    label: 'Loader',
    value: ({ loader_class }) => (
      <code>{loader_class}</code>
    )
  },
  {
    label: 'Processor',
    value: ({ processor_class }) => (
      <code>{processor_class}</code>
    )
  },
  {
    label: 'Normalizer',
    value: ({ normalizer_class }) => (
      <code>{normalizer_class}</code>
    )
  },
  {
    label: 'Import posts created after',
    value: ({ after }) => (
      <Time value={after} placeholder={noConstrants} />
    )
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
