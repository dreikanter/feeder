import { combineReducers } from 'redux'
import { connectRouter } from 'connected-react-router'
import feed from 'main/reducers/feedReducer'
import index from 'main/reducers/indexReducer'
import pending from 'main/reducers/pendingReducer'

export default history => combineReducers({
  feed,
  index,
  pending,
  router: connectRouter(history)
})
