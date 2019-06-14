import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faLink } from '@fortawesome/free-solid-svg-icons'
import DataTable from 'lib/components/DataTable'
import MutedZero from 'lib/components/MutedZero'
import Pending from 'lib/components/Pending'
import ReadableTime from 'lib/components/ReadableTime'

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: <FontAwesomeIcon icon={faLink} />,
    classes: 'min',
    value: ({ post_url }) => (
      <a href={post_url}>
        <FontAwesomeIcon icon={faLink} />
      </a>
    )
  },
  {
    title: 'Feed',
    classes: '',
    value: ({ feed_name, feed_url }) => (
      <a href={feed_url}>{feed_name}</a>
    )
  },
  {
    title: 'Comments',
    classes: '',
    value: ({ comments }) => (
      <MutedZero value={comments.length} />
    )
  },
  {
    title: 'Attachments',
    classes: '',
    value: ({ attachments }) => (
      <MutedZero value={attachments.length} />
    )
  },
  {
    title: 'Published at',
    classes: '',
    value: ({ published_at }) => (
      <ReadableTime value={published_at} />
    )
  },
  {
    title: 'Created at',
    classes: '',
    value: ({ created_at }) => (
      <ReadableTime value={created_at} />
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
