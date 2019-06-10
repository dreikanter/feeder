import Index from 'index'
// import Feed from 'feed'
import routingPaths from 'main/routingPaths'

export default [
  {
    path: routingPaths.rootPath,
    component: Index
  },
  {
    path: routingPaths.postsPath,
    // TODO
    component: Index
  },
  {
    path: routingPaths.updatesPath,
    // TODO
    component: Index
  },
  {
    path: routingPaths.feedPath,
    // TODO
    component: Index
  }
]
