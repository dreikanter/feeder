import React from 'react'
import ReactDOM from 'react-dom'
import Main from 'main'
import 'bootstrap/dist/css/bootstrap.min.css'

window.addEventListener('load', () => {
  const element = document.getElementById('root')
  ReactDOM.render(<Main />, element)
})
