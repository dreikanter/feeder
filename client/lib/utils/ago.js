import {
  distanceInWordsToNow,
  isValid,
  parse
} from 'date-fns'

export default function ago (date) {
  const value = parse(date)

  if (!isValid(value)) {
    return null
  }

  return distanceInWordsToNow(value, { addSuffix: true })
}
