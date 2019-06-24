import React from 'react'
import './style.scss'

const Footer = () => (
  <footer className="Footer">
    <div className="container">
      <ul className="Footer__list">
        <li className="Footer__item">
          <a href="https://github.com/dreikanter/feeder">GitHub</a>
        </li>
        <li className="Footer__item">
          <a href="https://github.com/dreikanter/feeder/issues">Bug reports</a>
        </li>
        <li className="Footer__item">
          <a href="https://freefeed.net/feeder">Freefeed</a>
        </li>
      </ul>
    </div>
  </footer>
)

export default Footer
