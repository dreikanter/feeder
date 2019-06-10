import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import './style'

const valueClasses = value => cc([
  'Stats__value',
  { 'Stats__value--empty': !value }
])

const Stats = ({ items, placeholder }) => (
  <div className="card-group Stats">
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
  items: PropTypes.arrayOf(PropTypes.shape({
    title: PropTypes.string,
    value: PropTypes.any
  })),
  placeholder: PropTypes.oneOfType([PropTypes.string, PropTypes.node])
}

Stats.defaultProps = {
  items: [],
  placeholder: '–'
}

export default Stats
