const secondsInMinute = 60
const secondsInHour = 3600

function every (seconds) {
  if (seconds < secondsInMinute) {
    return `every ${seconds} seconds`
  }

  if (seconds < secondsInHour) {
    return `every ${(seconds / secondsInMinute).toLocaleString()} minutes`
  }

  return `every ${(seconds / secondsInHour).toLocaleString()} hours`
}

export default every
