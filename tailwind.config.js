/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/assets/builds/**/*.css'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
  // Ensure Tailwind works with Propshaft
  corePlugins: {
    preflight: true,
  }
}
