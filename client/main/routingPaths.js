import paths from 'main/paths'

const patterns = {
  id: ':id(\\d+)',
  name: ':name([\\w_-]+)'
}

const routingPaths = {
  rootPath:
    paths.rootPath(),

  feedPath:
    paths.feedPath(patterns.name),

  postsPath:
    paths.postsPath(),

  updatesPath:
    paths.updatesPath()
}

export default Object.assign({}, ...Object.keys(routingPaths).map(
  key => ({ [key]: unescape(routingPaths[key]) })
))
