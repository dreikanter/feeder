import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import Pending from 'lib/components/Pending'
import ReadableTime from 'lib/components/ReadableTime'
import UpdateStatus from 'updates/components/UpdateStatus'
import paths from 'main/paths'

/* eslint-disable react/prop-types, camelcase */
const updateCols = [
  {
    title: 'Status',
    headClasses: 'text-center min',
    cellClasses: 'text-center min',
    value: ({ status }) => (
      <UpdateStatus value={status} />
    )
  },
  {
    title: 'Feed name',
    value: ({ feed_name }) => (
      <a href={paths.feedPath(feed_name)}>{feed_name}</a>
    )
  },
  {
    title: 'New posts',
    value: ({ posts_count }) => (
      <MutedZero value={posts_count} />
    )
  },
  {
    title: 'Executed at',
    value: ({ created_at }) => (
      <ReadableTime value={created_at} />
    )
  },
  {
    title: 'Duration',
    value: ({ duration }) => (
      `${duration.toPrecision(2)} s`
    )
  },
]

const batchCols = [
  {
    title: 'Status',
    headClasses: 'text-center min',
    cellClasses: 'text-center min',
    value: ({ }) => (1)
  },
  {
    title: 'Status',
    headClasses: '',
    cellClasses: '',
    value: ({ }) => (2)
  },
]
/* eslint-enable react/prop-types, camelcase */

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const {
      batches,
      updates,
      pending
    } = this.props

    if (pending) {
      return (
        <Pending />
      )
    }

    return (
      <Fragment>
        <h1>Recent feed updates</h1>
        <DataTable
          cols={updateCols}
          records={updates}
        />
        <h1>Batch updates</h1>
        <DataTable
          cols={batchCols}
          records={batches}
        />
      </Fragment>
    )
  }
}

Main.propTypes = {
  batches: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool,
  updates: PropTypes.array
}

Main.defaultProps = {
  batches: [],
  load: undefined,
  pending: false,
  updates: []
}

export default Main
