import {
  LOAD_BATCHES_PENDING,
  LOAD_BATCHES_FULFILLED,
  LOAD_BATCHES_REJECTED
} from 'main/actions/loadBatches'

export default (state = {}, action) => {
  switch (action.type) {
    case LOAD_BATCHES_PENDING:
    case LOAD_BATCHES_REJECTED: {
      return []
    }

    case LOAD_BATCHES_FULFILLED: {
      return action.payload.data.batches
    }

    default: {
      return state
    }
  }
}
