const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: ['./src/**/*.html', './src/**/*.md'],
  theme: {
    screens: {
      xs: '375px',
      mob: '450px',
      sm: '640px',
      md: '768px',
      tab: '860px',
      lg: '1024px',
      xl: '1280px',
      '2xl': '1536px',
      hd: '1920px',
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        helvetica: ['Helvetica', ...defaultTheme.fontFamily.sans],
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
      animation: {
        write: 'write 4s linear forwards',
      },
      keyframes: {
        write: {
          '100%': { 'stroke-dashoffset': '0' },
        },
      },
      scale: {
        105: '105%',
      },
    },
  },
  variants: {},
  plugins: [require('@tailwindcss/typography')],
};
