import { createBrowserHistory } from 'history'
import promise from 'redux-promise-middleware'
import thunk from 'redux-thunk'
import { applyMiddleware, compose, createStore } from 'redux'
import { routerMiddleware } from 'connected-react-router'
import createReducer from 'main/createReducer'
import initState from 'main/initState'

export const history = createBrowserHistory()

const middleware = [
  routerMiddleware(history),
  promise,
  thunk
]

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
const storeEnhancer = composeEnhancers(applyMiddleware(...middleware))
const createStoreWithMiddleware = storeEnhancer(createStore)
const reducer = createReducer(history)

export const store = createStoreWithMiddleware(reducer, initState)
