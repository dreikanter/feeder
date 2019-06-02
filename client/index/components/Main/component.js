import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Placeholder from 'main/components/Placeholder'

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
      <div>
        Index
      </div>
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
