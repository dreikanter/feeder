import React, { Fragment } from 'react'
import { Provider } from 'react-redux'
import { Route, Switch } from 'react-router-dom'
import { ConnectedRouter } from 'connected-react-router'
import Footer from 'main/components/Footer'
import Navbar from 'lib/components/Navbar'
import PageNotFound from 'lib/components/PageNotFound'
import { store, history } from 'main/store'
import paths from 'main/paths'
import routes from 'main/routes'
import 'main/style.scss'

const navLinks = [
  {
    path: paths.rootPath(),
    label: 'Feeds'
  },
  {
    path: paths.postsPath(),
    label: 'Posts'
  },
  {
    path: paths.updatesPath(),
    label: 'Updates'
  },
  {
    path: paths.aboutPath(),
    label: 'About'
  }
]

const App = () => (
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Fragment>
        <Navbar
          brandTitle="FreeFeed Feeder"
          brandLink={paths.rootPath()}
          links={navLinks}
        />
        <main role="main" className="container">
          <Switch>
            {routes.map((params, index) => (
              <Route key={index} exact {...params} />
            ))}
            <Route component={PageNotFound} />
          </Switch>
        </main>
      </Fragment>
      <Footer />
    </ConnectedRouter>
  </Provider>
)

export default App
