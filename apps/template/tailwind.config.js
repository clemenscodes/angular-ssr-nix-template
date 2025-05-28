import { join } from 'path';

const tailwindBaseConfig = require('../../tailwind.config.js');

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindBaseConfig],
  content: [
    join(__dirname, 'src/**/*!(*.stories|*.spec).{ts,tsx,html}'),
    join(__dirname, '../../libs/**/*!(*.stories|*.spec).{ts,tsx,html}'),
  ],
};
