import sortImport from '@ianvs/prettier-plugin-sort-imports';
import * as prettierTailwind from 'prettier-plugin-tailwindcss';

/** @type {import('prettier').Config} */
export default {
  plugins: [sortImport, prettierTailwind],
  importOrder: [
    '<TYPES>^(@nestjs/(.*)$)',
    '<TYPES>',
    '',
    '^(@nestjs/(.*)$)',
    '<THIRD_PARTY_MODULES>',
    '',
    '^@workspace/(.*)$',
    '',
    '^#(.*)$',
    '',
    '^[../]',
    '^[./]',
  ],
  importOrderParserPlugins: [
    'typescript',
    'jsx',
    'decorators-legacy',
    'classProperties',
    'exportDefaultFrom',
    'importAssertions',
  ],
  importOrderTypeScriptVersion: '5.0.0',
  singleQuote: true,
  semi: true,
  tabWidth: 2,
  printWidth: 100,
  trailingComma: 'all',
  arrowParens: 'always',
};
