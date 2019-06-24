import moment from 'moment'

function formatTime (value, placeholder = null) {
  if (!value) {
    return placeholder
  }

  return moment(value).format('lll')
}

export default formatTime
