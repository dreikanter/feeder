import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_FEED_POSTS = 'main/LOAD_FEED_POSTS'

export const LOAD_FEED_POSTS_PENDING = pending(LOAD_FEED_POSTS)

export const LOAD_FEED_POSTS_FULFILLED = fulfilled(LOAD_FEED_POSTS)

export const LOAD_FEED_POSTS_REJECTED = rejected(LOAD_FEED_POSTS)

export function loadFeedPosts (feedId) {
  return {
    type: LOAD_FEED_POSTS,
    meta: { feedId },
    payload: axios.get(paths.apiFeedPostsPath(feedId))
  }
}
