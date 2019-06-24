export default activity => (
  Object.keys(activity).map(date => ({ count: activity[date], date }))
)
