import { Link } from 'react-router-dom'
import React from 'react'
import PropTypes from 'prop-types'
import DataTable from 'lib/components/DataTable'
import ago from 'lib/utils/ago'
import paths from 'main/paths'

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
    cellClasses: 'text-right',
    value: ({ posts_count }) => posts_count
  },
  {
    title: 'Last post',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-right text-nowrap',
    value: ({ last_post_created_at }) => ago(last_post_created_at)
  },
  {
    title: 'Refreshed at',
    headClasses: 'col-auto text-nowrap',
    cellClasses: 'text-right text-nowrap',
    value: ({ refreshed_at }) => ago(refreshed_at)
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
