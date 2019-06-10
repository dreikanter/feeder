import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_FEEDS = 'main/LOAD_FEEDS'

export const LOAD_FEEDS_PENDING = pending(LOAD_FEEDS)

export const LOAD_FEEDS_FULFILLED = fulfilled(LOAD_FEEDS)

export const LOAD_FEEDS_REJECTED = rejected(LOAD_FEEDS)

export function loadFeeds () {
  return {
    type: LOAD_FEEDS,
    payload: axios.get(paths.apiFeedsPath())
  }
}
