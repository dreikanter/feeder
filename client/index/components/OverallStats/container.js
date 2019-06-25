import { connect } from 'react-redux'
import { statsSelector } from 'main/selectors'
import OverallStats from './component'

const mapStateToProps = state => ({
  stats: statsSelector(state)
})

export default connect(mapStateToProps)(OverallStats)
