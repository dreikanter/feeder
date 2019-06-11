import {
  LOAD_ACTIVITY_PENDING,
  LOAD_ACTIVITY_FULFILLED,
  LOAD_ACTIVITY_REJECTED
} from 'main/actions/loadActivity'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_ACTIVITY_PENDING:
    case LOAD_ACTIVITY_REJECTED: {
      return []
    }

    case LOAD_ACTIVITY_FULFILLED: {
      return action.payload.data.activity
    }

    default: {
      return state
    }
  }
}
