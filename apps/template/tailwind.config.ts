import { join } from 'path'
import type { Config } from 'tailwindcss/dist/lib.mjs'

import baseConfig from '../../tailwind.config'

export default {
  presets: [baseConfig],
  content: [
    join(__dirname, 'src/**/*!(*.stories|*.spec).{ts,tsx,html}'),
    join(__dirname, '../../libs/**/*!(*.stories|*.spec).{ts,tsx,html}'),
  ],
} satisfies Config
