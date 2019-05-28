import { createBrowserHistory } from 'history'
import promise from 'redux-promise-middleware'
import thunk from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import { createStore, applyMiddleware } from 'redux'
import { routerMiddleware } from 'connected-react-router'
import createRootReducer from 'main/reducer'
import initState from 'main/initState'

export const history = createBrowserHistory()

const middleware = [
  routerMiddleware(history),
  promise,
  thunk
]

export const store = createStore(
  createRootReducer(history),
  initState,
  composeWithDevTools(applyMiddleware(...middleware))
)
