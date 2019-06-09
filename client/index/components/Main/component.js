import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'main/components/Placeholder'
import Stats from 'main/components/Stats'

class Main extends Component {
  componentDidMount () {
    const { load } = this.props
    load()
  }

  render () {
    const { pending, stats } = this.props

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
  pending: PropTypes.bool,
  stats: PropTypes.arrayOf(PropTypes.object)
}

Main.defaultProps = {
  load: undefined,
  pending: false,
  stats: []
}

export default Main
