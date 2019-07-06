import React, { Component } from 'react'
import PropTypes from 'prop-types'

import {
  Link,
  NavLink as RoutedNavLink
} from 'react-router-dom'

import BootstrapNavbar from 'reactstrap/es/Navbar'
import Collapse from 'reactstrap/es/Collapse'
import Nav from 'reactstrap/es/Nav'
import NavbarBrand from 'reactstrap/es/NavbarBrand'
import NavbarToggler from 'reactstrap/es/NavbarToggler'
import NavItem from 'reactstrap/es/NavItem'
import NavLink from 'reactstrap/es/NavLink'

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
