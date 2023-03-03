const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: ['./src/**/*.html', './src/**/*.md'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      width: {
        icon: '48px',
      },
      height: {
        icon: '48px',
      },
      maxWidth: {
        icon: '48px',
        icon_padding: '72px',
      },
    },
  },
  variants: {},
  plugins: [require('@tailwindcss/typography')],
};
