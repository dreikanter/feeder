import {
  LOAD_UPDATES_PENDING,
  LOAD_UPDATES_FULFILLED,
  LOAD_UPDATES_REJECTED
} from 'main/actions/loadUpdates'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_UPDATES_PENDING:
    case LOAD_UPDATES_REJECTED: {
      return []
    }

    case LOAD_UPDATES_FULFILLED: {
      return action.payload.data
    }

    default: {
      return state
    }
  }
}
