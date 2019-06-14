import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import Pending from 'lib/components/Pending'
import ReadableTime from 'lib/components/ReadableTime'
import UpdateStatus from 'updates/components/UpdateStatus'
import paths from 'main/paths'

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: 'Status',
    classes: 'text-center min',
    value: ({ status }) => (
      <UpdateStatus value={status} />
    )
  },
  {
    title: 'Feed name',
    classes: '',
    value: ({ feed_name }) => (
      <a href={paths.feedPath(feed_name)}>{feed_name}</a>
    )
  },
  {
    title: 'New posts',
    classes: '',
    value: ({ posts_count }) => (
      <MutedZero value={posts_count} />
    )
  },
  {
    title: 'Executed at',
    classes: '',
    value: ({ created_at }) => (
      <ReadableTime value={created_at} />
    )
  },
  {
    title: 'Duration',
    classes: '',
    value: ({ duration }) => (
      `${duration.toPrecision(2)} s`
    )
  },
]
/* eslint-enable react/prop-types, camelcase */

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { updates, pending } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <Fragment>
        <h1>Recent posts</h1>
        <DataTable
          cols={cols}
          records={updates}
        />
      </Fragment>
    )
  }
}

Main.propTypes = {
  updates: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  updates: [],
  load: undefined,
  pending: false
}

export default Main
