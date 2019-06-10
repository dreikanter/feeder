import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_BATCHES = 'main/LOAD_BATCHES'

export const LOAD_BATCHES_PENDING = pending(LOAD_BATCHES)

export const LOAD_BATCHES_FULFILLED = fulfilled(LOAD_BATCHES)

export const LOAD_BATCHES_REJECTED = rejected(LOAD_BATCHES)

export function loadBatches () {
  return {
    type: LOAD_BATCHES,
    payload: axios.get(paths.apiBatchesPath())
  }
}
