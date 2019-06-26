import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import Mute from 'lib/components/Mute'
import './style'

const valueClasses = value => cc([
  'Stats__value',
  { 'Stats__value--empty': !value }
])

const Stats = ({ className, items, placeholder }) => (
  <div className={cc(['card-group', 'mb-3', 'Stats', className])}>
    {items.map(({ title, value }, index) => (
      <div className="card" key={index}>
        <div className="card-body">
          <div className="Stats__title">{title}</div>
          <div className={valueClasses(value)}>{value || placeholder}</div>
        </div>
      </div>
    ))}
  </div>
)

Stats.propTypes = {
  className: PropTypes.string,
  items: PropTypes.arrayOf(PropTypes.shape({
    title: PropTypes.string,
    value: PropTypes.any
  })),
  placeholder: PropTypes.oneOfType([PropTypes.string, PropTypes.node])
}

Stats.defaultProps = {
  className: undefined,
  items: [],
  placeholder: <Mute>–</Mute>
}

export default Stats
