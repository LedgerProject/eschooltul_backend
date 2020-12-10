const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  purge: [
    './app/**/*.html.erb',
    './app/**/*.tsx',
  ],
  theme: {
    extend: {
      fontWeight: ['hover', 'focus'],
      fontFamily: {
        sans: ['Montserrat Alternates', ...defaultTheme.fontFamily.sans],
      },
      width: { 
        '9/10': '90%', 
      }
    },
  },
  variants: {
    display: ['responsive', 'group-hover', 'group-focus'],
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
