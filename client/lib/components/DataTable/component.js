import cc from 'classcat'
import React from 'react'
import PropTypes from 'prop-types'
import './style.scss'

function DataTable ({
  className,
  click,
  cols,
  records
}) {
  if (!cols.length) {
    return null
  }

  const tableClassName = cc([
    'table',
    'table-bordered',
    {
      'table-hover': !!click
    },
    'DataTable',
    className
  ])

  return (
    <div className="table-responsive">
      <table className={tableClassName}>
        <thead>
          <tr>
            {cols.map(({ headClasses, title }, index) => (
              <th
                key={index}
                className={headClasses}
                scope="col"
              >
                {title}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {records.map((row, index) => (
            <tr
              key={index}
              onClick={() => click && click(row, index)}
              className="DataTable__row"
            >
              {cols.map(({ cellClasses, value }, colIndex) => (
                <td key={colIndex} className={cellClasses}>{value(row)}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

DataTable.propTypes = {
  className: PropTypes.string,
  click: PropTypes.func,
  cols: PropTypes.arrayOf(PropTypes.object),
  records: PropTypes.arrayOf(PropTypes.object)
}

DataTable.defaultProps = {
  className: undefined,
  click: undefined,
  cols: [],
  records: []
}

export default DataTable
