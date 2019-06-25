import moment from 'moment'

export default function ago (date) {
  if (date === undefined) {
    return null
  }

  const value = moment(date)

  if (!value.isValid()) {
    return null
  }

  return value.fromNow()
}
