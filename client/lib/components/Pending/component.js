import React from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faSpinner } from '@fortawesome/free-solid-svg-icons'
import Placeholder from 'lib/components/Placeholder'

const Pending = () => (
  <Placeholder>
    <FontAwesomeIcon
      className="text-muted"
      icon={faSpinner}
      pulse
      size="2x"
    />
  </Placeholder>
)

export default Pending
