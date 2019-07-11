import invariant from 'invariant'
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

const isValid = status => Object.keys(updateStatus).includes(status)

function UpdateStatus ({ value }) {
  invariant(isValid(value), 'unknown update status')

  if (value === updateStatus.success) {
    return (
      <FontAwesomeIcon
        className="text-success"
        icon={faCheckCircle}
      />
    )
  }

  return (
    <FontAwesomeIcon
      className="text-danger"
      icon={faExclamationTriangle}
    />
  )
}

UpdateStatus.propTypes = {
  value: PropTypes.string.isRequired
}

export default UpdateStatus
