import { combineReducers } from 'redux'
import { connectRouter } from 'connected-react-router'
import feed from 'main/reducers/feedReducer'
import index from 'main/reducers/indexReducer'
import pending from 'main/reducers/pendingReducer'
import stats from 'main/reducers/statsReducer'
import posts from 'main/reducers/postsReducer'
import updates from 'main/reducers/updatesReducer'
import activity from 'main/reducers/activityReducer'
import batches from 'main/reducers/batchesReducer'
import errors from 'main/reducers/errorsReducer'
import feedPosts from 'main/reducers/feedPostsReducer'
import feedUpdates from 'main/reducers/feedUpdatesReducer'
import feedActivity from 'main/reducers/feedActivityReducer'

export default history => combineReducers({
  activity,
  batches,
  errors,
  feed,
  feedActivity,
  feedPosts,
  feedUpdates,
  index,
  pending,
  posts,
  router: connectRouter(history),
  stats,
  updates
})
