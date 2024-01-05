const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        red: {
          500: "#ef4444",
        },
        primary: colors.forest,
      },
    },
  },
  plugins: [require("daisyui")]
}
