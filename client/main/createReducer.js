import { combineReducers } from 'redux'
import { connectRouter } from 'connected-react-router'
import index from 'index/reducer'
// import feed from 'feed/reducer'
import pending from 'main/reducers/pendingReducer'

export default history => combineReducers({
  // feed,
  index,
  pending,
  router: connectRouter(history)
})
