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
      },
      screens: {
        'xs': '480px',
        'sm': '600px',
        'md': '840px',
        'lg': '960px',
        'xl': '1280px',
        '2xl': '1440px',
        'full': '1600px'
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
