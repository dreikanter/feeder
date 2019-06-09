import {
  LOAD_FEEDS_PENDING,
  LOAD_FEEDS_FULFILLED,
  LOAD_FEEDS_REJECTED
} from 'main/actions/loadFeeds'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_FEEDS_PENDING:
    case LOAD_FEEDS_REJECTED: {
      return {}
    }

    case LOAD_FEEDS_FULFILLED: {
      return action.payload.data.meta
    }

    default: {
      return state
    }
  }
}
