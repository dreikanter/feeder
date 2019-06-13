// SEE: https://github.com/javiercf/react-markdown-loader

module.exports = {
  test: /\.md$/,
  use: [
    'babel-loader',
    'react-markdown-loader'
  ]
}
