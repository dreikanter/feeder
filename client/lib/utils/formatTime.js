import moment from 'moment'

function formatTime (value) {
  const time = moment(value)

  if (!time.isValid()) {
    return null
  }

  return time.format('lll')
}

export default formatTime
