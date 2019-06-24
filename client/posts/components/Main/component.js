import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faLink } from '@fortawesome/free-solid-svg-icons'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import Pending from 'lib/components/Pending'
import Time from 'lib/components/Time'
import paths from 'main/paths'

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: <FontAwesomeIcon icon={faLink} />,
    headClasses: 'min',
    value: ({ post_url }) => (
      <a href={post_url}>
        <FontAwesomeIcon icon={faLink} />
      </a>
    )
  },
  {
    title: 'Feed',
    value: ({ feed_name }) => (
      <a href={paths.feedPath(feed_name)}>{feed_name}</a>
    )
  },
  {
    title: 'Comments',
    headClasses: '',
    cellClasses: '',
    value: ({ comments }) => (
      <MutedZero>{comments.length}</MutedZero>
    )
  },
  {
    title: 'Attachments',
    headClasses: '',
    cellClasses: '',
    value: ({ attachments }) => (
      <MutedZero>{attachments.length}</MutedZero>
    )
  },
  {
    title: 'Published at',
    headClasses: '',
    cellClasses: '',
    value: ({ published_at }) => (
      <Time value={published_at} />
    )
  },
  {
    title: 'Created at',
    headClasses: '',
    cellClasses: '',
    value: ({ created_at }) => (
      <Time value={created_at} />
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
    const { posts, pending } = this.props

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
          records={posts}
        />
      </Fragment>
    )
  }
}

Main.propTypes = {
  posts: PropTypes.array,
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  posts: [],
  load: undefined,
  pending: false
}

export default Main
