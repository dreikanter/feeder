import React from 'react'
import PropTypes from 'prop-types'
import './style'

const Stats = ({ items }) => (
  <div className="card-group Stats">
    {items.map(({ title, value }, index) => (
      <div className="card" key={index}>
        <div className="card-body">
          <h5 className="card-title">{title}</h5>
          <p className="card-text">{value}</p>
        </div>
      </div>
    ))}
  </div>
)

Stats.propTypes = {
  items: PropTypes.arrayOf(PropTypes.object)
}

Stats.defaultProps = {
  items: []
}

export default Stats
