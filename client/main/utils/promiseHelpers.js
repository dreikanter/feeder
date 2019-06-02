import { ActionType } from 'redux-promise-middleware'

export const pending = actionType => (
  [actionType, ActionType.Pending].join('_')
)

export const fulfilled = actionType => (
  [actionType, ActionType.Fulfilled].join('_')
)

export const rejected = actionType => (
  [actionType, ActionType.Rejected].join('_')
)
