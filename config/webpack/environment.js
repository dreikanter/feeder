const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const markdown = require('./loaders/markdown')

environment.loaders.prepend('erb', erb)
environment.loaders.prepend('md', markdown)
module.exports = environment
