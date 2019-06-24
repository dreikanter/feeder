import { connect } from 'react-redux'
import { push } from 'connected-react-router'
import { loadActivity } from 'main/actions/loadActivity'
import { loadFeeds } from 'main/actions/loadFeeds'
import paths from 'main/paths'

import {
  activitySelector,
  indexSelector,
  pendingFeedsPageSelector,
  statValuesSelector
} from 'main/selectors'

import Main from './component'

const mapActivityValues = values => Object.keys(values).map(key => {
  const date = new Date(Date.parse(key))
  const count = values[key]

  const formattedDate = [
    date.getDate(),
    date.getMonth() + 1,
    date.getFullYear()
  ].join('/')

  const tip = `${formattedDate}: ${count}`

  return { count, date, tip }
})

const mapStateToProps = state => ({
  activity: mapActivityValues(activitySelector(state)),
  feeds: indexSelector(state),
  pending: pendingFeedsPageSelector(state),
  stats: statValuesSelector(state)
})

const mapDispatchToProps = dispatch => ({
  clickFeed: ({ name }) => dispatch(push(paths.feedPath(name))),
  load: () => {
    dispatch(loadFeeds())
    dispatch(loadActivity())
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Main)
