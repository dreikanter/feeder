const presetEnv = require('@babel/preset-env')
const presetReact = require('@babel/preset-react')
const rmPropTypes = require('babel-plugin-transform-react-remove-prop-types')

/* eslint-disable-next-line func-names */
module.exports = function (api) {
  const validEnv = ['development', 'test', 'production']
  const currentEnv = api.env()
  const isDevelopmentEnv = api.env('development')
  const isProductionEnv = api.env('production')
  const isTestEnv = api.env('test')

  if (!validEnv.includes(currentEnv)) {
    throw new Error(`unknown environment: ${JSON.stringify(currentEnv)}`)
  }

  const presets = [
    isTestEnv && [presetEnv, {
      targets: {
        node: 'current'
      }
    }],
    (isProductionEnv || isDevelopmentEnv) && [presetEnv, {
      forceAllTransforms: true,
      useBuiltIns: 'entry',
      corejs: '2.0.0',
      modules: false,
      exclude: ['transform-typeof-symbol']
    }],
    [presetReact, {
      development: isDevelopmentEnv || isTestEnv,
      useBuiltIns: true,
      corejs: '2.0.0'
    }]
  ].filter(Boolean)

  const plugins = [
    isProductionEnv && [
      rmPropTypes,
      {
        removeImport: true
      }
    ]
  ].filter(Boolean)

  return { presets, plugins }
}
