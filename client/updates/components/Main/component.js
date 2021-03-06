import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import seconds from 'lib/utils/seconds'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import Pending from 'lib/components/Pending'
import Time from 'lib/components/Time'
import UpdateStatus from 'updates/components/UpdateStatus'
import paths from 'main/paths'

/* eslint-disable react/prop-types, camelcase */
const updateCols = [
  {
    title: 'Status',
    headClasses: 'text-center text-nowrap min',
    cellClasses: 'text-center text-nowrap min',
    value: ({ status }) => (
      <UpdateStatus value={status} />
    )
  },
  {
    title: 'Feed name',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ feed_name }) => {
      if (!feed_name) {
        return null
      }

      return (
        <a href={paths.feedPath(feed_name)}>{feed_name}</a>
      )
    }
  },
  {
    title: 'New posts',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ posts_count }) => (
      <MutedZero>{posts_count}</MutedZero>
    )
  },
  {
    title: 'Executed at',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ created_at }) => (
      <Time value={created_at} />
    )
  },
  {
    title: 'Duration',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ duration }) => seconds(duration)
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
          hover
          records={updates}
        />
      </Fragment>
    )
  }
}

Main.propTypes = {
  load: PropTypes.func,
  pending: PropTypes.bool,
  updates: PropTypes.array
}

Main.defaultProps = {
  load: undefined,
  pending: false,
  updates: []
}

export default Main
