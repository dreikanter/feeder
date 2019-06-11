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
    'table-hover',
    'DataTable',
    className
  ])

  return (
    <div className="table-responsive">
      <table className={tableClassName}>
        <thead>
          <tr>
            {cols.map(({ classes, title }, index) => (
              <th
                key={index}
                className={classes}
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
              {cols.map(({ classes, value }, colIndex) => (
                <td key={colIndex} className={classes}>{value(row)}</td>
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
