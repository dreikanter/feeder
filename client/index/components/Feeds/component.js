import {
  isAfter,
  parse,
  subSeconds
} from 'date-fns'

import { Link } from 'react-router-dom'
import React from 'react'
import PropTypes from 'prop-types'
import DataTable from 'lib/components/DataTable'
import Mute from 'lib/components/Mute'
import MutedZero from 'lib/components/MutedZero'
import Time from 'lib/components/Time'
import paths from 'main/paths'

const recencyThreshold = 3600 // seconds

function humanizedTime (value, highlight = true) {
  const time = parse(value)
  const threshold = subSeconds(new Date(), recencyThreshold, 'seconds')

  const result = (
    <Time
      ago
      value={value}
      placeholder={<Mute>–</Mute>}
    />
  )

  if (highlight && isAfter(time, threshold)) {
    return (
      <mark>{result}</mark>
    )
  }

  return result
}

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: 'Feed name',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ id, name }) => (
      <Link to={paths.feedPath(id)}>{name}</Link>
    )
  },
  {
    title: 'Posts',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-nowrap',
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
    headClasses: 'col-auto text-nowrap d-none d-md-table-cell',
    cellClasses: 'text-nowrap d-none d-md-table-cell',
    value: ({ refreshed_at }) => humanizedTime(refreshed_at, false)
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
