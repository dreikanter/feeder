import createBrowserHistory from 'history/createBrowserHistory'
import promiseMiddleware from 'redux-promise-middleware'
import thunk from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import { createStore, applyMiddleware } from 'redux'
import { routerMiddleware } from 'connected-react-router'
import createRootReducer from 'main/reducer'
import initState from 'main/initState'

export const history = createBrowserHistory()

const middleware = [
  routerMiddleware(history),
  promiseMiddleware(),
  thunk
]

export const store = createStore(
  createRootReducer(history),
  initState,
  composeWithDevTools(applyMiddleware(...middleware))
)
