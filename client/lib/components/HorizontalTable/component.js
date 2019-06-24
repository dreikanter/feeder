import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import './style.scss'

function HorizontalTable ({
  className,
  object,
  presenters
}) {
  if (!object || !presenters.length) {
    return null
  }

  const tableClassName = cc([
    'table',
    'table-bordered',
    'HorizontalTable',
    className
  ])

  return (
    <div className="table-responsive">
      <table className={tableClassName}>
        <tbody>
          {presenters.map(({ label, value }, index) => (
            <tr key={index}>
              <th className="HorizontalTable__header" scope="row">
                {label}
              </th>
              <td className="HorizontalTable__value">
                {value(object)}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

HorizontalTable.propTypes = {
  className: PropTypes.string,
  object: PropTypes.object,
  presenters: PropTypes.arrayOf(PropTypes.object)
}

HorizontalTable.defaultProps = {
  className: undefined,
  object: undefined,
  presenters: []
}

export default HorizontalTable
