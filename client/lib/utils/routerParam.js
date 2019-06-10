import get from 'lodash/get'

export default ({ match }, name, defaultValue = undefined) => (
  get(match, ['params', name], defaultValue)
)
