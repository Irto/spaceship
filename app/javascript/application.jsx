// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

import React from "react"
import ReactDOM from "react-dom/client"
import SpaceshipTerminal from "./components/SpaceshipTerminal"

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("terminal-root")
  if (el) {
    const root = ReactDOM.createRoot(el)
    root.render(<SpaceshipTerminal />)
  }
})
