const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Helvetica Inter var", ...defaultTheme.fontFamily.sans],
      },
      height: {
        22: "88px",
        110: "440px",
      },
      width: {
        62: "246px",
        848: "848px",
      },
      padding: {
        15: "60px",
      },
      borderRadius: {
        15: "15px",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
