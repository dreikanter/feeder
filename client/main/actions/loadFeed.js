import axios from 'axios'
import { pending, fulfilled, rejected } from 'main/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_FEED = 'main/LOAD_FEED'

export const LOAD_FEED_PENDING = pending(LOAD_FEED)

export const LOAD_FEED_FULFILLED = fulfilled(LOAD_FEED)

export const LOAD_FEED_REJECTED = rejected(LOAD_FEED)

export function loadFeeds (feedId) {
  return {
    type: LOAD_FEED,
    meta: { feedId },
    payload: axios.get(paths.apiFeedPath(feedId))
  }
}
