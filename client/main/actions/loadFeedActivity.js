import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_FEED_ACTIVITY = 'main/LOAD_FEED_ACTIVITY'

export const LOAD_FEED_ACTIVITY_PENDING = pending(LOAD_FEED_ACTIVITY)

export const LOAD_FEED_ACTIVITY_FULFILLED = fulfilled(LOAD_FEED_ACTIVITY)

export const LOAD_FEED_ACTIVITY_REJECTED = rejected(LOAD_FEED_ACTIVITY)

export function loadFeedActivity (feedId) {
  return {
    type: LOAD_FEED_ACTIVITY,
    meta: { feedId },
    payload: axios.get(paths.apiFeedActivityPath(feedId))
  }
}
