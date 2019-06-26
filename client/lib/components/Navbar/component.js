import React, { Component } from 'react'
import PropTypes from 'prop-types'

import {
  Link,
  NavLink as RoutedNavLink
} from 'react-router-dom'

import {
  Collapse,
  Navbar as BootstrapNavbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink
} from 'reactstrap'

class Navbar extends Component {
  constructor (props) {
    super(props)
    this.state = { isOpen: false }
    this.toggle = this.toggle.bind(this)
  }

  toggle () {
    const { isOpen } = this.state
    this.setState({ isOpen: !isOpen })
  }

  render () {
    const {
      brandLink,
      brandTitle,
      links
    } = this.props

    const { isOpen } = this.state

    return (
      <BootstrapNavbar color="light" light expand="lg" className="mb-3">
        <div className="container">
          <NavbarBrand tag={Link} to={brandLink}>
            {brandTitle}
          </NavbarBrand>
          <NavbarToggler onClick={this.toggle} />
          <Collapse isOpen={isOpen} navbar>
            <Nav navbar>
              {links.map(({ label, path }, index) => (
                <NavItem key={index}>
                  <NavLink
                    tag={RoutedNavLink}
                    to={path}
                    activeClassName="active"
                    className="nav-link"
                    exact
                  >
                    {label}
                  </NavLink>
                </NavItem>
              ))}
            </Nav>
          </Collapse>
        </div>
      </BootstrapNavbar>
    )
  }
}

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
