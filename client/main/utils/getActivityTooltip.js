import React, { Fragment } from 'react'
import pluralize from 'pluralize'

function getActivityTooltip (activity, date) {
  const count = activity[date]

  if (!count) {
    return null
  }

  return (
    <Fragment>
      {date}
      {' → '}
      <b>{pluralize('post', count, true)}</b>
    </Fragment>
  )
}

export default getActivityTooltip
