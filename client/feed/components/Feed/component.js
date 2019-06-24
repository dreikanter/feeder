import React from 'react'
import PropTypes from 'prop-types'
import every from 'lib/utils/every'
import HorizontalTable from 'lib/components/HorizontalTable'
import Mute from 'lib/components/Mute'
import MutedZero from 'lib/components/MutedZero'
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
    value: ({ posts_count }) => (
      <MutedZero>{posts_count}</MutedZero>
    )
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
      <a href={url}>{url}</a>
    )
  },
  {
    label: 'Loader',
    value: ({ loader }) => (
      <code>{loader || 'default'}</code>
    )
  },
  {
    label: 'Processor',
    value: ({ processor }) => (
      <code>{processor}</code>
    )
  },
  {
    label: 'Normalizer',
    value: ({ normalizer }) => (
      <code>{normalizer}</code>
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
