import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'

function HorizontalTable ({
  className,
  values
}) {
  if (!values.length) {
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
          {values.map(({ label, value }, index) => (
            <tr key={index} className="HorizontalTable__row">
              <th scope="row" className="">{label}</th>
              <td className="">{value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

HorizontalTable.propTypes = {
  className: PropTypes.string,
  values: PropTypes.arrayOf(PropTypes.object)
}

HorizontalTable.defaultProps = {
  className: undefined,
  values: []
}

export default HorizontalTable
