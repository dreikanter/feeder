import moment from 'moment'
import { Link } from 'react-router-dom'
import React from 'react'
import PropTypes from 'prop-types'
import ago from 'lib/utils/ago'
import ConditionalPlaceholder from 'lib/components/ConditionalPlaceholder'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import paths from 'main/paths'

const recencyThreshold = 3600 // seconds

function humanizedTime (value) {
  const time = moment(value)
  const threshold = moment().subtract(recencyThreshold, 'seconds')

  if (time.isAfter(threshold)) {
    return (
      <mark>{ago(value)}</mark>
    )
  }

  return (
    <ConditionalPlaceholder
      condition={!!value}
      placeholder="–"
    >
      {ago(value)}
    </ConditionalPlaceholder>
  )
}

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: 'Feed name',
    headClasses: 'col-auto text-nowrap',
    value: ({ id, name }) => (
      <Link to={paths.feedPath(id)}>{name}</Link>
    )
  },
  {
    title: 'Posts',
    headClasses: 'col-auto text-nowrap',
    cellClasses: '',
    value: ({ posts_count }) => (
      <MutedZero>{posts_count}</MutedZero>
    )
  },
  {
    title: 'Last post',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ last_post_created_at }) => humanizedTime(last_post_created_at)
  },
  {
    title: 'Refreshed at',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ refreshed_at }) => humanizedTime(refreshed_at)
  },
]
/* eslint-enable react/prop-types, camelcase */

const Feeds = ({ click, records }) => (
  <DataTable
    className="Feeds"
    click={click}
    cols={cols}
    records={records}
  />
)

Feeds.propTypes = {
  click: PropTypes.func,
  records: PropTypes.array
}

Feeds.defaultProps = {
  click: undefined,
  records: []
}

export default Feeds
