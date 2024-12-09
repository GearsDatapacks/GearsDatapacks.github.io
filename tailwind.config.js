const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content:["./src/**/*.gleam"],
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
        celandine: ['Celandine', ...defaultTheme.fontFamily.sans],
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
        write: 'write 3s linear forwards',
      },
      keyframes: {
        write: {
          '90%': { 'stroke-dashoffset': '0', fill: 'rgba(255,255,255,0)' },
          '100%': { fill: 'rgba(255,255,255,255)' },
        },
      },
      scale: {
        105: '105%',
      },
    },
  },
  variants: {},
  plugins: [],
};

