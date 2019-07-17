import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faComment } from '@fortawesome/free-solid-svg-icons/faComment'
import { faLink } from '@fortawesome/free-solid-svg-icons/faLink'
import { faFile } from '@fortawesome/free-solid-svg-icons/faFile'
import DataTable from 'lib/components/DataTable'
import Pending from 'lib/components/Pending'
import Time from 'lib/components/Time'
import paths from 'main/paths'
import './style.scss'

const repeatIcons = (icon, length) => (
  <Fragment>
    {Array.from({ length }).map((_, index) => (
      <FontAwesomeIcon
        className={`Main__icon Main__icon-${icon.iconName}`}
        icon={icon}
        key={index}
      />
    ))}
  </Fragment>
)

/* eslint-disable react/prop-types, camelcase */
const cols = [
  {
    title: <FontAwesomeIcon icon={faLink} />,
    headClasses: 'min text-nowrap',
    value: ({ post_url }) => (
      <a href={post_url}>
        <FontAwesomeIcon icon={faLink} />
      </a>
    )
  },
  {
    title: 'Feed',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ feed_name }) => (
      <a href={paths.feedPath(feed_name)}>{feed_name}</a>
    )
  },
  {
    title: 'Comments',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ comments }) => repeatIcons(faComment, comments.length)
  },
  {
    title: 'Attachments',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ attachments }) => repeatIcons(faFile, attachments.length)
  },
  {
    title: 'Published at',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
    value: ({ published_at }) => (
      <Time value={published_at} />
    )
  },
  {
    title: 'Created at',
    headClasses: 'text-nowrap',
    cellClasses: 'text-nowrap',
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
    const {
      posts,
      pending
    } = this.props

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
          hover
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
