import { Link } from 'react-router-dom'
import React from 'react'
import PropTypes from 'prop-types'
import DataTable from 'lib/components/DataTable'
import ago from 'lib/utils/ago'
import paths from 'main/paths'

const cols = [
  {
    title: 'Feed name',
    classes: '',
    value: ({ id, name }) => (
      <Link to={paths.feedPath(id)}>{name}</Link>
    )
  },
  {
    title: 'Posts',
    classes: 'min text-center',
    // eslint-disable-next-line
    value: ({ posts_count }) => posts_count
  },
  {
    title: 'Last post',
    classes: '',
    // eslint-disable-next-line
    value: ({ last_post_created_at }) => ago(last_post_created_at)
  },
  {
    title: 'Refreshed at',
    classes: '',
    // eslint-disable-next-line
    value: ({ refreshed_at }) => ago(refreshed_at)
  },
]

const Feeds = ({ records }) => (
  <DataTable
    className="Feeds"
    cols={cols}
    records={records}
  />
)

Feeds.propTypes = {
  records: PropTypes.array
}

Feeds.defaultProps = {
  records: []
}

export default Feeds
