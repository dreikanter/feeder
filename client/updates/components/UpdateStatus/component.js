import React from 'react'
import PropTypes from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import {
  faCheckCircle
} from '@fortawesome/free-solid-svg-icons/faCheckCircle'

import {
  faExclamationTriangle
} from '@fortawesome/free-solid-svg-icons/faExclamationTriangle'

// TODO: Use shared enum for available update status values ('pull' series)

function UpdateStatus ({ value }) {
  switch (value) {
    case 'success': {
      return (
        <FontAwesomeIcon
          className="text-success"
          icon={faCheckCircle}
        />
      )
    }

    case 'has-errors': {
      return (
        <FontAwesomeIcon
          className="text-danger"
          icon={faExclamationTriangle}
        />
      )
    }

    default: {
      return null
    }
  }
}

UpdateStatus.propTypes = {
  value: PropTypes.string.isRequired
}

export default UpdateStatus
