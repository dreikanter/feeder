import React from 'react'
import PropTypes from 'prop-types'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import {
  faCheckCircle
} from '@fortawesome/free-solid-svg-icons/faCheckCircle'

import {
  faExclamationTriangle
} from '@fortawesome/free-solid-svg-icons/faExclamationTriangle'

import { updateStatus } from 'main/enums'

function UpdateStatus ({ value }) {
  if (value === updateStatus.success) {
    return (
      <FontAwesomeIcon
        className="text-success"
        icon={faCheckCircle}
      />
    )
  }

  if (value === updateStatus.has_errors) {
    return (
      <FontAwesomeIcon
        className="text-warning"
        icon={faExclamationTriangle}
      />
    )
  }

  return null
}

UpdateStatus.propTypes = {
  value: PropTypes.string.isRequired
}

export default UpdateStatus
