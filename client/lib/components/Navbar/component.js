import React from 'react'
import PropTypes from 'prop-types'
import { Link, NavLink } from 'react-router-dom'

const Navbar = ({
  brandLink,
  brandTitle,
  links
}) => (
  <nav className="navbar navbar-expand-lg navbar-light bg-light">
    <div className="container">
      <Link className="navbar-brand" to={brandLink}>{brandTitle}</Link>
      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarNav"
        aria-controls="navbarNav"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span className="navbar-toggler-icon" />
      </button>
      <div className="collapse navbar-collapse" id="navbarNav">
        <ul className="navbar-nav">
          {links.map(({ label, path }, index) => (
            <li className="nav-item" key={index}>
              <NavLink
                activeClassName="active"
                className="nav-link"
                exact
                to={path}
              >
                {label}
              </NavLink>
            </li>
          ))}
        </ul>
      </div>
    </div>
  </nav>
)

Navbar.propTypes = {
  brandTitle: PropTypes.string,
  brandLink: PropTypes.string,
  links: PropTypes.arrayOf(PropTypes.shape({
    path: PropTypes.string,
    label: PropTypes.string
  }))
}

Navbar.defaultProps = {
  brandTitle: undefined,
  brandLink: '/',
  links: []
}

export default Navbar
