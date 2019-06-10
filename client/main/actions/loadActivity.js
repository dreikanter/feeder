import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_ACTIVITY = 'main/LOAD_ACTIVITY'

export const LOAD_ACTIVITY_PENDING = pending(LOAD_ACTIVITY)

export const LOAD_ACTIVITY_FULFILLED = fulfilled(LOAD_ACTIVITY)

export const LOAD_ACTIVITY_REJECTED = rejected(LOAD_ACTIVITY)

export function loadActivity () {
  return {
    type: LOAD_ACTIVITY,
    payload: axios.get(paths.apiActivityPath())
  }
}
