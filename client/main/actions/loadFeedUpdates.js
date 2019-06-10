import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_FEED_UPDATES = 'main/LOAD_FEED_UPDATES'

export const LOAD_FEED_UPDATES_PENDING = pending(LOAD_FEED_UPDATES)

export const LOAD_FEED_UPDATES_FULFILLED = fulfilled(LOAD_FEED_UPDATES)

export const LOAD_FEED_UPDATES_REJECTED = rejected(LOAD_FEED_UPDATES)

export function loadFeedUpdates (feedId) {
  return {
    type: LOAD_FEED_UPDATES,
    meta: { feedId },
    payload: axios.get(paths.apiFeedUpdatesPath(feedId))
  }
}
