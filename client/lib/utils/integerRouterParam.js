import routerParam from './routerParam'

export default (props, name, defaultValue = undefined) => (
  parseInt(routerParam(props, name, defaultValue), 10) || defaultValue
)
