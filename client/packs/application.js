import React from 'react'
import ReactDOM from 'react-dom'
import Main from 'main'

window.addEventListener('load', () => {
  const element = document.getElementById('root')
  ReactDOM.render(<Main />, element)
})
