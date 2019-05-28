import React from 'react'
import { Provider } from 'react-redux'
import { Route, Switch } from 'react-router-dom'
import { ConnectedRouter } from 'connected-react-router'
import PageNotFound from 'main/components/PageNotFound'
import { store, history } from 'main/store'
import routes from 'main/routes'

const App = () => (
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Switch>
        {routes.map((params, index) => (
          <Route key={index} exact {...params} />
        ))}
        <Route component={PageNotFound} />
      </Switch>
    </ConnectedRouter>
  </Provider>
)

export default App
