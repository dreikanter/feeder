import omit from 'lodash/omit'

import {
  fulfillments,
  pendings,
  rejections
} from 'main/actions'

export default function (state = {}, { type, payload }) {
  const newError = rejections[type]

  if (newError) {
    return Object.assign({}, state, { [newError]: payload })
  }

  const revokedError = pendings[type] || fulfillments[type]

  if (revokedError) {
    return omit(state, revokedError)
  }

  return state
}
