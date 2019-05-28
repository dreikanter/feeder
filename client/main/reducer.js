import { combineReducers } from 'redux'
import { connectRouter } from 'connected-react-router'
import index from 'index/reducer'
// import feed from 'feed/reducer'

export default history => combineReducers({
  // feed,
  index,
  router: connectRouter(history)
})
