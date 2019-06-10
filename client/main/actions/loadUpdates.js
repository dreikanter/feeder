import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_UPDATES = 'main/LOAD_UPDATES'

export const LOAD_UPDATES_PENDING = pending(LOAD_UPDATES)

export const LOAD_UPDATES_FULFILLED = fulfilled(LOAD_UPDATES)

export const LOAD_UPDATES_REJECTED = rejected(LOAD_UPDATES)

export function loadUpdates () {
  return {
    type: LOAD_UPDATES,
    payload: axios.get(paths.apiUpdatesPath())
  }
}
