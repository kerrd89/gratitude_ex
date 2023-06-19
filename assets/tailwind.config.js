// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");
const colors = require("./colors.js");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  // Ensure we generate classes for rotational transformations used in thermostat widget.
  safelist: [
    ...[...Array(131).keys()].flatMap((i) => [
      `rotate-[${i}deg]`,
      `rotate-[-${i}deg]`,
    ]),
  ],
  theme: {
    // These OVERRIDE the standard Tailwind screen sizes.
    screens: {
      sm: "600px",
      md: "905px",
      lg: "1240px",
      xl: "1440px",
    },
    // This OVERRIDES (does not extend) the standard Tailwind colors; we cannot
    // use the standard ones.
    colors: colors,
    extend: {
      fontSize: {
        xxs: "0.625rem",
      },
      opacity: {
        pressed: 0.12,
        hovered: 0.08,
        disabled: 0.38,
      },
      transitionProperty: {
        "max-height": "max-height",
        sidebar: "opacity, max-width",
      },
      animation: {
        "action-sheet-in": "action-sheet-in 0.3s ease-in",
        "action-sheet-out": "action-sheet-out 0.3s ease-out",
        "action-sheet-in-full": "action-sheet-in-full 0.3s ease-in",
        "action-sheet-out-full-to-half":
          "action-sheet-out-full-to-half 0.3s ease-out",
        "action-sheet-out-full-to-close":
          "action-sheet-out-full-to-close 0.3s ease-out",
        "overlay-in": "overlay-in 0.2s ease-in",
        "overlay-out": "overlay-out 0.2s ease-out",
        "modal-in": "modal-in 0.3s ease-in",
        "modal-out": "modal-out 0.3s ease-out",
        spin: "spin 1s linear infinite",
      },
      keyframes: {
        "action-sheet-in": {
          "0%": { height: 0 },
          "100%": { height: "50vh" },
        },
        "action-sheet-out": {
          "0%": { height: "50vh" },
          "100%": { height: 0 },
        },
        "action-sheet-in-full": {
          "0%": { height: "50vh" },
          "100%": { height: "100vh" },
        },
        "action-sheet-out-full-to-half": {
          "0%": { height: "100vh" },
          "100%": { height: "50vh" },
        },
        "action-sheet-out-full-to-close": {
          "0%": { height: "100vh" },
          "100%": { height: 0 },
        },
        "overlay-in": {
          "0%": { opacity: 0 },
          "100%": { opacity: 1 },
        },
        "overlay-out": {
          "0%": { opacity: 1 },
          "100%": { opacity: 0 },
        },
        "modal-in": {
          "0%": { height: 0 },
          "100%": { height: "100vh" },
        },
        "modal-out": {
          "0%": { height: "100vh" },
          "100%": { height: 0 },
        },
      },
    },
    fontFamily: {
      sans: ["Poppins", "Arial", "sans-serif"],
      "material-symbols-rounded": ["Material Symbols Rounded"],
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addBase }) => addBase({ html: { color: colors.grey[1000] } })),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Embeds Hero Icons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    // plugin(function ({ matchComponents, theme }) {
    //   let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized");
    //   let values = {};
    //   let icons = [
    //     ["", "/24/outline"],
    //     ["-solid", "/24/solid"],
    //     ["-mini", "/20/solid"],
    //   ];
    //   icons.forEach(([suffix, dir]) => {
    //     fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
    //       let name = path.basename(file, ".svg") + suffix;
    //       values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
    //     });
    //   });
    //   matchComponents(
    //     {
    //       hero: ({ name, fullPath }) => {
    //         let content = fs
    //           .readFileSync(fullPath)
    //           .toString()
    //           .replace(/\r?\n|\r/g, "");
    //         return {
    //           [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
    //           "-webkit-mask": `var(--hero-${name})`,
    //           mask: `var(--hero-${name})`,
    //           "background-color": "currentColor",
    //           "vertical-align": "middle",
    //           display: "inline-block",
    //           width: theme("spacing.5"),
    //           height: theme("spacing.5"),
    //         };
    //       },
    //     },
    //     { values }
    //   );
    // }),

    // Applies when a child has focus, for example:
    //
    //     <div class="bg-white child-focus:bg-grey-1000">
    //
    plugin(({ addVariant }) => addVariant("child-focus", ["&:has(>:focus)"])),
  ],
};
