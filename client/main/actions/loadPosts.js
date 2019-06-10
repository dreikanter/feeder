import axios from 'axios'
import { pending, fulfilled, rejected } from 'lib/utils/promiseHelpers'
import paths from 'main/paths'

export const LOAD_POSTS = 'main/LOAD_POSTS'

export const LOAD_POSTS_PENDING = pending(LOAD_POSTS)

export const LOAD_POSTS_FULFILLED = fulfilled(LOAD_POSTS)

export const LOAD_POSTS_REJECTED = rejected(LOAD_POSTS)

export function loadPosts () {
  return {
    type: LOAD_POSTS,
    payload: axios.get(paths.apiPostsPath())
  }
}
