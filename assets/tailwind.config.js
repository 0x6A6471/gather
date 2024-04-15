// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const colors = require("tailwindcss/colors");
const fs = require("fs");
const path = require("path");

delete colors["lightBlue"];
delete colors["warmGray"];
delete colors["trueGray"];
delete colors["coolGray"];
delete colors["blueGray"];

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/gather_web.ex",
    "../lib/gather_web/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        ...colors,
        gray: colors.stone,
        gather: {
          50: "#faf7f2",
          100: "#f3eee1",
          200: "#ece4d1",
          300: "#d6c39b",
          400: "#c4a573",
          500: "#b88f57",
          600: "#aa7c4c",
          700: "#8e6440",
          800: "#735239",
          900: "#5e4430",
          950: "#322218",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [
        ".phx-no-feedback&",
        ".phx-no-feedback &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ]),
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ]),
    ),
  ],
};
