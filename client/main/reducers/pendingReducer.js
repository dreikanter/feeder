import union from 'lodash/union'
import without from 'lodash/without'

import {
  fulfillments,
  pendings,
  rejections
} from 'main/actions'

export default function (state = {}, { type }) {
  const pendingAction = pendings[type]

  if (pendingAction) {
    return union(state, [pendingAction])
  }

  const finishedAction = fulfillments[type] || rejections[type]

  if (finishedAction) {
    return without(state, finishedAction)
  }

  return state
}
