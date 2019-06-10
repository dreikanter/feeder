import moment from 'moment'

export default function ago (date) {
  const value = moment(date)

  if (!value.isValid()) {
    return null
  }

  return value.fromNow()
}
