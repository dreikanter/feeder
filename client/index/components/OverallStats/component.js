import isEmpty from 'lodash/isEmpty'
import React from 'react'
import PropTypes from 'prop-types'
import ago from 'lib/utils/ago'
import Stats from 'lib/components/Stats'

const formatNumber = number => new Intl.NumberFormat().format(number)

function mapStats (stats) {
  if (isEmpty(stats)) {
    return []
  }

  return ([
    {
      title: 'Feeds',
      value: formatNumber(stats.feeds_count)
    },
    {
      title: 'Posts',
      value: formatNumber(stats.posts_count)
    },
    {
      title: 'Subscribers',
      value: formatNumber(stats.subscriptions_count)
    },
    {
      title: 'Last update',
      value: ago(stats.last_update)
    },
    {
      title: 'Last post',
      value: ago(stats.last_post_created_at)
    }
  ])
}

const OverallStats = ({ stats }) => (
  <Stats items={mapStats(stats)} />
)

OverallStats.propTypes = {
  stats: PropTypes.object
}

OverallStats.defaultProps = {
  stats: []
}

export default OverallStats
