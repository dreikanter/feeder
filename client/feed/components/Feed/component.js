import moment from 'moment'
import React from 'react'
import PropTypes from 'prop-types'
import HorizontalTable from 'lib/components/HorizontalTable'
import every from 'lib/utils/every'

/* eslint-disable react/prop-types, camelcase */
const feedValues = ({
  id,
  name,
  posts_count,
  refreshed_at,
  created_at,
  updated_at,
  url,
  processor,
  normalizer,
  after,
  refresh_interval,
  loader,
  import_limit,
  last_post_created_at
}) => ([
  {
    label: 'ID',
    value: id
  },
  {
    label: 'Name',
    value: name
  },
  {
    label: 'Freefeed group',
    value: `https://freefeed.net/${name}`
  },
  {
    label: 'Posts count',
    value: posts_count
  },
  {
    label: 'Refreshed at',
    value: moment(refreshed_at)
  },
  {
    label: 'Last post created at',
    value: moment(last_post_created_at)
  },
  {
    label: 'Updated at',
    value: moment(updated_at)
  },
  {
    label: 'Created at',
    value: moment(created_at)
  },
  {
    label: 'Source URL',
    value: url
  },
  {
    label: 'Loader',
    value: loader
  },
  {
    label: 'Processor',
    value: processor
  },
  {
    label: 'Normalizer',
    value: normalizer
  },
  {
    label: 'Import posts created after',
    value: moment(after).format()
  },
  {
    label: 'Refresh interval',
    value: every(refresh_interval)
  },
  {
    label: 'Import limit',
    value: import_limit
  }
])
/* eslint-enable react/prop-types, camelcase */

const Feed = ({ feed }) => (
  <HorizontalTable values={feedValues(feed)} />
)

Feed.propTypes = {
  feed: PropTypes.object.isRequired
}

export default Feed
