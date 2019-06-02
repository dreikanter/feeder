import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'main/components/Placeholder'
import Stats from 'main/components/Stats'

const stats = [
  {
    title: 'Subscribers',
    value: 1000
  },
  {
    title: 'Subscribers',
    value: 1000
  },
  {
    title: 'Subscribers',
    value: 1000
  },
]

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { pending } = this.props

    if (pending) {
      return (
        <Placeholder label="Loading..." />
      )
    }

    return (
      <Fragment>
        <Stats items={stats} />
      </Fragment>
    )
  }
}

Main.propTypes = {
  load: PropTypes.func,
  pending: PropTypes.bool
}

Main.defaultProps = {
  load: undefined,
  pending: undefined
}

export default Main
