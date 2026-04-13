import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: ['class'],
  content: [
    './app/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './hooks/**/*.{ts,tsx}',
    './lib/**/*.{ts,tsx}'
  ],
  theme: {
    container: {
      center: true,
      padding: '1rem',
      screens: {
        '2xl': '1320px'
      }
    },
    extend: {
      colors: {
        background: '#09090b',
        foreground: '#fafafa',
        card: '#111113',
        muted: '#1e1f24',
        accent: '#22c55e',
        border: '#27272a'
      }
    }
  },
  plugins: []
};

export default config;
