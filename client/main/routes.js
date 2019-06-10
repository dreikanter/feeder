import Index from 'index'
import Feed from 'feed'
import Posts from 'posts'
import Updates from 'updates'
import routingPaths from 'main/routingPaths'

export default [
  {
    path: routingPaths.rootPath,
    component: Index
  },
  {
    path: routingPaths.postsPath,
    component: Posts
  },
  {
    path: routingPaths.updatesPath,
    component: Updates
  },
  {
    path: routingPaths.feedPath,
    component: Feed
  }
]
